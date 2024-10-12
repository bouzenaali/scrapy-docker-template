# Scrapy Docker Template

This template provides a ready-to-use setup for containerizing Scrapy projects using Docker. It allows you to easily deploy your web scrapers in isolated Docker environments and save scraped data to local files or databases.

## Getting Started
## 1. Prepare Your Scrapy Project

Make sure your Scrapy project is set up correctly and working locally before containerizing it. Here’s a basic structure for your Scrapy project:
```
your-scrapy-project/
│
├── scrapy.cfg
├── your_spider/
│   ├── __init__.py
│   ├── spiders/
│   │   └── your_spider.py
│   └── settings.py
├── requirements.txt
└── Dockerfile
```
- **scrapy.cfg**: Contains the configuration for the Scrapy project.
- **your_spider/**: This directory holds your Scrapy project, including spiders, pipelines, and settings.
- **requirements.txt**: Contains the Python dependencies for your project.

## 2. Create Your Dockerfile

- Base image: Using Python 3.11.
- WORKDIR: Sets the working directory to /app.
- COPY: Copies your project files into the container.
- Install dependencies: Install necessary system packages and Python dependencies.
- Create and use a virtual environment: Ensures an isolated environment for your Python dependencies.
- Scrapy spider execution: It runs your Scrapy spider (your_spider_name) and saves the data into /app/data/output.csv.

## 3. Ensure the Requirements are Correct

In your requirements.txt, list all the Python libraries your Scrapy project needs, including Scrapy itself. For example:
```
scrapy==2.11.2
pymongo==3.12.0  # if you're using MongoDB
mysql-connector-python==8.0.26  # if you're using MySQL
```
## 4. Build the Docker Image

Now, navigate to your project directory and build the Docker image:
```shell
docker build -t your-scrapy-image .
```
## 5. Run the Docker Container

After the image is built, run the container and mount the data directory to your local machine to persist the scraped data.
```shell
docker run -v $(pwd)/data:/app/data your-scrapy-image
```
This command:

- Runs the container.
- Mounts your local data folder (in the current working directory) to the /app/data folder inside the container so that the scraped data is saved outside the container.

## 6. Check the Output

After the container finishes running, check the data folder in your local project directory. You should see a file like output.json (or output.csv/output.xml depending on your choice), containing the scraped data.

## 7. Optional: Storing Data in a Database

If you prefer to store data in a database (like MySQL or MongoDB), follow these additional steps:

a. Install the Database Driver

Add the relevant driver (like pymongo or mysql-connector-python) to your requirements.txt. For example:
```
pymongo==3.12.0  # For MongoDB
mysql-connector-python==8.0.26  # For MySQL
```
b. Modify the Spider to Save Data in a Database

Update your spider’s parse function to insert data into a database instead of saving to a file.

Example for MongoDB:
```python
import pymongo

class YourSpider(scrapy.Spider):
    name = "your_spider_name"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        client = pymongo.MongoClient("mongodb://your-mongo-db-host:27017/")
        self.db = client["your_db_name"]
        self.collection = self.db["your_collection_name"]

    def parse(self, response):
        # Your scraping logic here...
        item = {
            'title': response.xpath('//h1/text()').get(),
            'price': response.xpath('//span[@class="price"]/text()').get(),
            # More fields...
        }

        # Insert data into MongoDB
        self.collection.insert_one(item)
```
Make sure the database connection details are available in your environment variables or configuration files.

## 8. Deploying to the Cloud

Once everything is working locally, you can deploy your Docker container to a cloud service such as AWS, Google Cloud, or Azure. Most cloud services support Docker containers, and you can use their container orchestration services like Kubernetes or Docker Swarm to manage your deployments.

## Summary of Steps:
```
1. Set up your Scrapy project and Dockerfile.
2. Write a Dockerfile with the necessary dependencies, including virtual environment setup.
3. Build the Docker image using docker build -t your-scrapy-image ..
4. Run the container with docker run -v $(pwd)/data:/app/data your-scrapy-image to scrape data and save it to a local file.
5. Optionally modify your spider to store data in a database (MongoDB, MySQL, etc.).
6. Deploy to the cloud if necessary.
```
