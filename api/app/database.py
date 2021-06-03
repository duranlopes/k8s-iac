from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os

DB_USER = os.environ['DB_USER']
DB_PASS = os.environ['DB_PASS']
DB_SERVER = os.environ['DB_SERVER']
DB_PORT = os.environ['DB_PORT']


SQLALCHEMY_DATABASE_URL = "mysql+pymysql://{}:{}@{}:{}/users".format(DB_USER, DB_PASS, DB_SERVER, DB_PORT)

engine = create_engine("mysql+pymysql://{}:{}@{}/users".format(DB_USER, DB_PASS, DB_SERVER))
#engine = create_engine(
#    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
#)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

