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
