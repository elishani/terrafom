# terraform

after installtion login to nginx machine add the web ip to /etc/nginx/nginx.cong line 5
before :80
Restart nginx 
-# systemctl restart nginx 



# /etc/nginx/nginx.conf
events { }

http {
	upstream beckend {
		server :80;
		}
	server {
		listen 443 ssl;
        ssl_certificate /etc/nginx/ssl/eli.crt;
        ssl_certificate_key /etc/nginx/ssl/eli.key;
		location / {
			proxy_pass http://beckend/;
		}
	}
}
