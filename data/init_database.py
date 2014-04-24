# -*- coding: utf-8 -*-
"""
Created on Wed Mar 12 17:31:41 2014

@author: Tim Richardson <tim@rewire.it>
"""
import os
import time

from unipath import Path
from Bio import GenBank
from sqlalchemy import create_engine
from sqlalchemy import Column, Integer, String, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import ForeignKey
from sqlalchemy.orm import sessionmaker#, relationship, backref

from settings import SETTINGS

def main():
    records = parse()
    models, db_session = create_and_load_db()
    import ipdb; ipdb.set_trace() ############################## Breakpoint ##############################
    load_to_db(records, models, db_session)
    choice = raw_input('Would you like to make a database dump? (y/n) :')
    if choice.strip() in ('y','Y','yes'):
        dumpdatabase()

def parse(path='./flat_files/'):
    path = Path(path)
    print "parsing records at {}".format(path.absolute())

    records = []
    for p in path.listdir():
        try:
            gbr = GenBank.read(open(p))
            records.append(gbr)
        except:
            print 'error with file', p
    print "parsed %s records.." % len(records)

    return records

def create_and_load_db():
    global SETTINGS
    SETTINGS = Settings(**SETTINGS)

    if not hasattr(SETTINGS.DB, 'USER'):
        SETTINGS.DB.USER = raw_input('Please enter username for database : ')

    if not hasattr(SETTINGS.DB, 'PASSWD'):
        SETTINGS.DB.PASSWD = raw_input('Enter passwd for mysql user "{}": '.format(SETTINGS.DB.USER))

    conn_string = 'mysql+mysqldb://{user}:{passwd}@{location}:{port}'.format(
                                                user = SETTINGS.DB.USER,
                                                passwd = SETTINGS.DB.PASSWD,
                                                location = SETTINGS.DB.LOCATION,
                                                port = SETTINGS.DB.PORT,
                                                                             )
    #engine = create_engine('sqlite:///:memory:')
    engine = create_engine(conn_string, echo=False)
    try:
        engine.execute('CREATE DATABASE IF NOT EXISTS {}'.format(SETTINGS.DB.DATABASE_NAME))
    except:
        raise Exception('wrong password?')

    engine.execute('USE {}'.format(SETTINGS.DB.DATABASE_NAME))
    Session = sessionmaker(bind=engine)
    session = Session()

    models = Models()

    models.Base.metadata.create_all(engine) # create the tables

    return models, session

def load_to_db(records, models, session):
    for record in records:
        gene = models.Gene(gene_identifier=int(record.gi) ,nucleotide_sequence=record.sequence ,chromosome_location=record.locus)
        session.add(gene)
        session.commit()

        for feature in record.features:

            if feature.key == 'CDS':
                translation, name  = None, None
                for qualifier in feature.qualifiers:
                    if qualifier.key == '/translation=':
                        translation = qualifier.value.strip('"')
                    if qualifier.key == '/product=':
                        name = qualifier.value.strip('"')
                # create protein object
                protein = models.Protein(name=name, sequence=translation, gene_id=gene.gene_identifier)
                session.add(protein)
                session.commit()

            if feature.key == 'exon':
                start, end = feature.location.split('..')
                start, end = int(''.join([d for d in start if d.isdigit()])), int(''.join([d for d in end if d.isdigit()]))
                exon = models.Exon(start=start,end=end,gene_id=gene.gene_identifier)
                session.add(exon)
                session.commit()

        for accession in record.accession:
            acc = models.Accession(accession_number=accession, gene_id=gene.gene_identifier)
            session.add(acc)
            session.commit()

    print "Finised loading to database"

def dumpdatabase():
    global SETTINGS
    timestamp = time.strftime('%Y-%m-%d-%I:%M')
    dumpstring = "mysqldump -u {user} -p{passwd} -h {location} -e --opt -c {database} | gzip -c > {database}_{timestamp}.gz".format(
                        user = SETTINGS.DB.USER,
                        passwd = SETTINGS.DB.PASSWD,
                        location = SETTINGS.DB.LOCATION,
                        database = SETTINGS.DB.DATABASE_NAME,
                        timestamp = timestamp,
                        )
    os.popen(dumpstring)
    print "database dump complete.."


class Models():
    def __init__(self):
        Base = declarative_base()
        self.Base = Base

        class Gene(Base):
            __tablename__ = 'genes'

            gene_identifier= Column(Integer, primary_key=True)
            nucleotide_sequence = Column(Text)
            chromosome_location = Column(String(8))

        #    accession_numbers = relationship("Accession", backref="gene")
        #    exons = relationship("Exon", backref="gene")
        #    protein = relationship("Protein", backref="gene")
        self.Gene = Gene

        class Accession(Base):
            __tablename__ = 'accession_numbers'

            accession_number = Column(String(8), primary_key=True)
            gene_id = Column(Integer, ForeignKey('genes.gene_identifier'))

            #gene = relationship(Gene, backref='accession_numbers')
        self.Accession = Accession

        class Exon(Base):
            __tablename__ = 'exons'

            id = Column(Integer, primary_key=True)
            start = Column(Integer)
            end = Column(Integer)
            gene_id = Column(Integer, ForeignKey('genes.gene_identifier'))

            #gene = relationship(Gene, backref='exons')
        self.Exon = Exon

        class Protein(Base):
            __tablename__ = 'proteins'

            id = Column(Integer, primary_key=True)
            name = Column(String(128))
            sequence = Column(Text)
            gene_id = Column(Integer, ForeignKey('genes.gene_identifier'))

            #gene = relationship(Gene, backref='protein_products')
        self.Protein = Protein

class Settings:
    def __init__(self, **attrs):
        for key, value in attrs.iteritems():
            if type(value) is dict:
                attrs[key] = Settings(**value)
        self.__dict__.update(attrs)


if __name__ == '__main__':
    main()
