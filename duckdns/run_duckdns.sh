# Stop currently running container and remove it
docker stop duckdns; exit 0;
docker rm duckdns; exit 0;

# Create a new container (an instance made from the most recently downloaded image) with YOUR personal variables
docker create \
  --name=duckdns \
  -e TZ=America/Los_Angeles \
  -e SUBDOMAINS=702lap \
  -e TOKEN=6610b038-32db-4012-83e2-d7682dd726a7 \
  -e LOG_FILE=false \
  --restart unless-stopped \
  linuxserver/duckdns