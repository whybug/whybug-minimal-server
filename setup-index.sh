#!/bin/bash

curl -XDELETE 'localhost:9200/solutions-php?pretty'

curl -XPUT 'localhost:9200/solutions-php?pretty' -d '
{
    "settings": {
        "number_of_shards": 1,
        "analysis": {
            "filter": {
                "my_shingle_filter": {
                    "type":             "shingle",
                    "min_shingle_size": 2,
                    "max_shingle_size": 2,
                    "output_unigrams":  false
                }
            },
            "analyzer": {
                "my_shingle_analyzer": {
                    "type":             "custom",
                    "tokenizer":        "standard",
                    "filter": [
                        "lowercase",
                        "my_shingle_filter"
                    ]
                }
            }
        }
    }
}'

curl -XPUT 'localhost:9200/solutions-php/_mapping/solution?pretty' -d '
{
    "solution": {
        "properties": {
            "errorDescription": {
                "type": "string",
                "fields": {
                    "shingles": {
                        "type":     "string",
                        "analyzer": "my_shingle_analyzer"
                    }
                },
                "store": "yes"
            },
            "solutionDescription": {
                "type": "string",
                "index": "not_analyzed"
            }
        }
    }
}'

# curl "localhost:9200/solutions-php/_analyze?analyzer=my_shingle_analyzer&text=Access denied for user 'superuser'@'localhost' (using password: NO)"

curl "localhost:9200/solutions-php/_status?pretty"

curl -XPOST "localhost:9200/solutions-php/solution/_search?pretty" -d '
{
   "size": 10,
   "query": {
      "bool": {
         "must": {
            "match": {
               "errorDescription": {
                  "query": "Access denied for user test@localhost (using password: NO)"
               }
            }
         }
      }
   },
   "highlight": {
      "fields": {
         "errorDescription": {}
      }
   }
}'
