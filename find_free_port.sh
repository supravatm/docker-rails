#!/usr/bin/env bash
# find_service_ports.sh
# Detect free ports for Rails, MySQL, Elasticsearch and export them into .env

# Default port ranges
RAILS_START=3000
RAILS_END=3999
MYSQL_START=3306
MYSQL_END=3399
ES_START=9200
ES_END=9299

# Function: find first free port in range
find_free_port() {
  local start=$1
  local end=$2
  for ((port=$start; port<=$end; port++)); do
    if ! lsof -i :$port >/dev/null 2>&1; then
      echo $port
      return
    fi
  done
  echo "none"
}

echo "🔎 Scanning system for free ports..."

RAILS_PORT=$(find_free_port $RAILS_START $RAILS_END)
MYSQL_PORT=$(find_free_port $MYSQL_START $MYSQL_END)
ES_PORT=$(find_free_port $ES_START $ES_END)

if [ "$RAILS_PORT" == "none" ] || [ "$MYSQL_PORT" == "none" ] || [ "$ES_PORT" == "none" ]; then
  echo "❌ No available ports found in the expected ranges."
  exit 1
fi

echo "✅ Found available ports:"
echo "   Rails → $RAILS_PORT"
echo "   MySQL → $MYSQL_PORT"
echo "   Elasticsearch → $ES_PORT"

# Write to .env file
cat > .env <<EOF
RAILS_PORT=$RAILS_PORT
MYSQL_PORT=$MYSQL_PORT
ES_PORT=$ES_PORT
EOF

echo "👉 Ports saved to .env. Docker Compose will use them."
