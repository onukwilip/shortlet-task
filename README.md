# SHORTLET-ASSESSMENT

This is the API server the Shortlet assessment for the role of a Cloud engineer

## HOW TO USE

- **Run the project directly on your system**:

  > To run this project directly on your system you will need [**Node.Js**](https://nodejs.org/en/download) version **16.15.0** or higher

  - Run `git clone https://github.com/onukwilip/shortlet-task.git`
  - Run `npm install -f`
  - Run `npx tsc --build`
  - Run `npm start`

- **Run the project using Docker**:

  > To run this project as a container you will need [**Docker**](https://www.docker.com/products/docker-desktop/)

  - Run `git clone https://github.com/onukwilip/shortlet-task.git`
  - Run `docker build -t shortlet-task:latest .`
  - Run `docker run -p 5000:5000 -it -d --rm shortlet-task:latest`

- **OR pull image from container registry**

  - Run `docker pull prince2006/shortlet-task:latest`
  - Run `docker run -p 5000:5000 -it -d --rm prince2006/shortlet-task:latest`
