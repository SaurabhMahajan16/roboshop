frontend:
	bash components/frontend.sh
#make frontend will execute frontend

cart:
	bash components/cart.sh
#make cart will execute frontend
#make command only take 1 argument
mongo:
	bash components/mongo.sh

catalogue:
	bash components/catalogue.sh

user:
	bash components/user.sh

redis:
	bash components/redis.sh

mysql:
	bash components/mysql.sh

shipping:
	bash components/shipping.sh

rabbitmq:
	bash components/rabbitmq.sh

dispatch:
	bash components/dispatch.sh

payment:
	bash components/payment.sh

#makefile updated
