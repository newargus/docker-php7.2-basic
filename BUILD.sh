VERSION=$(curl -s -XGET https://api.github.com/repos/newargus/docker-php7.2-basic/tags | grep name -m 1 | awk '{print $2}' | cut -d'"' -f2)

docker buildx build --platform linux/amd64,linux/arm64 \
-f Dockerfile \
-t newargus/php7.2-basic:latest \
-t newargus/php7.2-basic:"${VERSION}" \
--build-arg TAG_VERSION="${VERSION}" \
--cpu-quota="400000" \
--memory=16g \
--push .