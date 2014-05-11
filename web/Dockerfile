FROM orchardup/nginx

# add site config
ADD etc/nginx/sites-available/example /etc/nginx/sites-available/example

# add custom launcher script
ADD run_nginx.sh /

CMD ["/run_nginx.sh"]
