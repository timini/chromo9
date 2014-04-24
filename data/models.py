from sqlalchemy import create_engine
from sqlalchemy import Column, Integer, String, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import ForeignKey
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm import relationship, backref

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
