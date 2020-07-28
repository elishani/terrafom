# terraform

after installtion login to nginx machine add the web ip to /etc/nginx/nginx.cong line 5<br>
before :80<br>
Restart nginx<br>
-# systemctl restart nginx<br>



# /etc/nginx/nginx.conf
events { }<br>
<br>
http {
	upstream beckend {<br>
		server :80;<br>
		}<br>
	server {<br>
		listen 443 ssl;<br>
        ssl_certificate /etc/nginx/ssl/eli.crt;<br>
        ssl_certificate_key /etc/nginx/ssl/eli.key;<br>
		location / {<br>
			proxy_pass http://beckend/;<br>
		}<br>
	}<br>
}<br>
