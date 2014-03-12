from sqlalchemy import create_engine
from sqlalchemy import Column, Integer, String, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import ForeignKey
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm import relationship, backref

SETTINGS = {
            'DB':{
                  'USER':'root',
                  'LOCATION':'localhost',
                  'PORT':'3306',
                  'DATABASE_NAME':'chromo9',
                  },
            }

class Settings:
    def __init__(self, **attrs):
        for key, value in attrs.iteritems():
            if type(value) is dict:
                attrs[key] = Settings(**value)
        self.__dict__.update(attrs)

SETTINGS = Settings(**SETTINGS)

if not hasattr(SETTINGS.DB, 'PASSWD'):
    SETTINGS.DB.PASSWD = raw_input('Enter passwd for mysql user {}'.format(SETTINGS.DB.USER))

conn_string = 'mysql+mysqldb://{user}:{passwd}@{location}:{port}'.format(
                                            user = SETTINGS.DB.USER,
                                            passwd = SETTINGS.DB.PASSWD,
                                            location = SETTINGS.DB.LOCATION,
                                            port = SETTINGS.DB.PORT,
                                                                         )
#engine = create_engine('sqlite:///:memory:')
engine = create_engine(conn_string, echo=False)
engine.execute('CREATE DATABASE IF NOT EXISTS {}'.format(SETTINGS.DB.DATABASE_NAME))
engine.execute('USE {}'.format(SETTINGS.DB.DATABASE_NAME))
Session = sessionmaker(bind=engine)
session = Session()

Base = declarative_base()

class Gene(Base):
    __tablename__ = 'genes'

    gene_identifier= Column(Integer, primary_key=True)
    nucleotide_sequence = Column(Text)
    chromosome_location = Column(String(8))


class Accession(Base):
    __tablename__ = 'accession_numbers'

    accession_number = Column(String(8), primary_key=True)
    gene_id = Column(Integer, ForeignKey('genes.gene_identifier'))

    gene = relationship(Gene, backref='accession_numbers')


class Exon(Base):
    __tablename__ = 'exons'

    id = Column(Integer, primary_key=True)
    start = Column(Integer)
    end = Column(Integer)
    gene_id = Column(Integer, ForeignKey('genes.gene_identifier'))

    gene = relationship(Gene, backref='exons')


class Protein(Base):
    __tablename__ = 'proteins'

    id = Column(Integer, primary_key=True)
    name = Column(String(128))
    sequence = Column(Text)
    gene_id = Column(Integer, ForeignKey('genes.gene_identifier'))

    gene = relationship(Gene, backref='protein_products')

Base.metadata.create_all(engine) # create the tables
