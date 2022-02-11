# this method of dockerbuild is called docker multistage, first docker is used to build the app,
# and the second docker is used to run the app
#This image is used to build the docker image for the application
#alpine image have minimal dependencies
FROM golang:1.17.0-alpine as build
#First define a workspace directory
WORKDIR /usr/src/app
COPY go.mod .
COPY main.go . 
RUN go mod tidy
RUN go build -o hello-app
#this other container is used to run the application 
#alpine is a very minimalist linux distribution
FROM alpine:latest
WORKDIR /app/
#Copy the binary to the container from other stage
COPY --from=build /usr/src/app/hello-app .
#change user to run app with less privileges
USER 1001
ENTRYPOINT [ "/app/hello-app" ]
