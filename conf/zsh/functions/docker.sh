#!/usr/bin/env zsh

# Completely removes all containers, images, and builder cache files.
docker-purge() {
    docker container prune -f
    docker image prune -f -a
    docker volume prune -f -a
    docker builder prune -f
    docker system prune -f
}


# Gets a list of tags from Docker Hub
dockerhub-tags() {
    if ! [[ "$#" -eq 2 || "$#" -eq 3 ]]; then
        printf "ERROR: missing required args\n\n"
        printf "usage: dockerhub-tags repo_name image_name <filter>\n\n"
        printf "   repo_name    required   ex. 'apache' (use 'library' for images w/no prefix)\n"
        printf "   image_name   required   ex. 'airflow'\n"
        printf "   filter       optional   ex. 'python-3'\n"
        return 1
    fi

    # Get count of results
    local count size pages remainder url
    size=100
    count=$(curl -s "https://hub.docker.com/v2/namespaces/${1}/repositories/${2}/tags?page_size=${size}" | jq -r '.count')
    pages=$((count / size))
    remainder=$((count % size))
    if [[ $remainder -gt 0 ]]; then
        pages=$((pages + 1))
    fi

    echo "Fetching ${size} items per page for ${pages} pages..."
    for ((page=1; page <= pages; page++))
    do
        url="https://hub.docker.com/v2/namespaces/${1}/repositories/${2}/tags?page=${page}"
        if [[ -z "$3" ]]; then
            curl -s "${url}" | jq -r '.results[].name'
        else
            curl -s "${url}" | jq -r '.results[].name' | grep -i "${3}"
        fi
    done
}
