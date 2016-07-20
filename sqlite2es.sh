#!/bin/bash

#curl -O download.elasticsearch.org/stream2es/stream2es; chmod +x stream2es
node convertjson |  ./stream2es stdin --target http://localhost:9200/solutions-php/solution

