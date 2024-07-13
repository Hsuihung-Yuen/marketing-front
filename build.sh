# 和电脑架构一样的docker
docker build -t thehhy/marketing-front-app:1.0 . --push

# amd版本
#docker buildx build --push --platform liunx/amd64 -t thehhy/marketing-front-app:1.0 .