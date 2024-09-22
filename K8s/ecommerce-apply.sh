#!/bin/bash


# To delete all services
kubectl delete all --all -n ecommerce

# Apply MongoDB deployment and service
kubectl apply -f persistantVolume-for-mongos.yml
kubectl apply -f persistentVolumeClaim.yml
kubectl apply -f mongo-deployment.yml
kubectl apply -f mongo-service.yml
kubectl apply -f hpa-mongo.yml

# Apply Backend deployment and service
kubectl apply -f backend-configmap.yml
kubectl apply -f backend-deployment.yml
kubectl apply -f backend-service.yml
kubectl apply -f hpa-backend.yml

# Apply Frontend deployment and service
kubectl apply -f frontend-configmap.yml
kubectl apply -f frontend-deployment.yml
kubectl apply -f frontend-service.yml
kubectl apply -f hpa-frontend.yml


echo "All Kubernetes resources have been applied."
