#!/bin/zsh

curl https://formation-kbrw.webflow.io/ > web/tuto.webflow/orders.html
# curl https://uploads-ssl.webflow.com/6054744dba3801f99dab395f/css/formation-kbrw.webflow.fb1837f2a.css > web/tuto.webflow/css/tuto.webflow.css
# wget -O - https://uploads-ssl.webflow.com/6054744dba3801f99dab395f/css/formation-kbrw.webflow.fb1837f2a.css | gunzip > web/tuto.webflow/css/tuto.webflow.css
curl --compressed https://uploads-ssl.webflow.com/6054744dba3801f99dab395f/css/formation-kbrw.webflow.fb1837f2a.css > web/tuto.webflow/css/tuto.webflow.css
curl https://formation-kbrw.webflow.io/order > web/tuto.webflow/order.html
