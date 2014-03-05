SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`GenBank`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`GenBank` (
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`GenBank_Entry`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`GenBank_Entry` (
  `idGenBank_Entry` INT NOT NULL ,
  `base_counts` VARCHAR(45) NULL ,
  `comment` VARCHAR(45) NULL ,
  `contig` VARCHAR(45) NULL ,
  `data_file_division` VARCHAR(45) NULL ,
  `date` VARCHAR(45) NULL ,
  `definition` VARCHAR(45) NULL ,
  `gi` VARCHAR(45) NULL ,
  `locus` VARCHAR(45) NULL ,
  `nid` VARCHAR(45) NULL ,
  `organism` VARCHAR(45) NULL ,
  `origin` VARCHAR(45) NULL ,
  `pid` VARCHAR(45) NULL ,
  `redisue_type` VARCHAR(45) NULL ,
  `segment` VARCHAR(45) NULL ,
  `sequence` VARCHAR(45) NULL ,
  `size` VARCHAR(45) NULL ,
  `source` VARCHAR(45) NULL ,
  `version` VARCHAR(45) NULL ,
  `wgs` VARCHAR(45) NULL ,
  PRIMARY KEY (`idGenBank_Entry`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Accession`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`Accession` (
  `GenBank_Entry_idGenBank_Entry` INT NOT NULL ,
  INDEX `fk_Accession_GenBank_Entry1_idx` (`GenBank_Entry_idGenBank_Entry` ASC) ,
  CONSTRAINT `fk_Accession_GenBank_Entry1`
    FOREIGN KEY (`GenBank_Entry_idGenBank_Entry` )
    REFERENCES `mydb`.`GenBank_Entry` (`idGenBank_Entry` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dblinks`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`dblinks` (
  `GenBank_Entry_idGenBank_Entry` INT NOT NULL ,
  INDEX `fk_dblinks_GenBank_Entry1_idx` (`GenBank_Entry_idGenBank_Entry` ASC) ,
  CONSTRAINT `fk_dblinks_GenBank_Entry1`
    FOREIGN KEY (`GenBank_Entry_idGenBank_Entry` )
    REFERENCES `mydb`.`GenBank_Entry` (`idGenBank_Entry` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`features`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`features` (
  `GenBank_Entry_idGenBank_Entry` INT NOT NULL ,
  `location` VARCHAR(45) NULL ,
  `key` VARCHAR(45) NULL ,
  `id` VARCHAR(45) NOT NULL ,
  INDEX `fk_features_GenBank_Entry_idx` (`GenBank_Entry_idGenBank_Entry` ASC) ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_features_GenBank_Entry`
    FOREIGN KEY (`GenBank_Entry_idGenBank_Entry` )
    REFERENCES `mydb`.`GenBank_Entry` (`idGenBank_Entry` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`keywords`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`keywords` (
  `GenBank_Entry_idGenBank_Entry` INT NOT NULL ,
  INDEX `fk_keywords_GenBank_Entry1_idx` (`GenBank_Entry_idGenBank_Entry` ASC) ,
  CONSTRAINT `fk_keywords_GenBank_Entry1`
    FOREIGN KEY (`GenBank_Entry_idGenBank_Entry` )
    REFERENCES `mydb`.`GenBank_Entry` (`idGenBank_Entry` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`primary`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`primary` (
  `GenBank_Entry_idGenBank_Entry` INT NOT NULL ,
  INDEX `fk_primary_GenBank_Entry1_idx` (`GenBank_Entry_idGenBank_Entry` ASC) ,
  CONSTRAINT `fk_primary_GenBank_Entry1`
    FOREIGN KEY (`GenBank_Entry_idGenBank_Entry` )
    REFERENCES `mydb`.`GenBank_Entry` (`idGenBank_Entry` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`references`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`references` (
  `GenBank_Entry_idGenBank_Entry` INT NOT NULL ,
  INDEX `fk_references_GenBank_Entry1_idx` (`GenBank_Entry_idGenBank_Entry` ASC) ,
  CONSTRAINT `fk_references_GenBank_Entry1`
    FOREIGN KEY (`GenBank_Entry_idGenBank_Entry` )
    REFERENCES `mydb`.`GenBank_Entry` (`idGenBank_Entry` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`projects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`projects` (
  `GenBank_Entry_idGenBank_Entry` INT NOT NULL ,
  INDEX `fk_projects_GenBank_Entry1_idx` (`GenBank_Entry_idGenBank_Entry` ASC) ,
  CONSTRAINT `fk_projects_GenBank_Entry1`
    FOREIGN KEY (`GenBank_Entry_idGenBank_Entry` )
    REFERENCES `mydb`.`GenBank_Entry` (`idGenBank_Entry` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`wgs_scafld`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`wgs_scafld` (
  `GenBank_Entry_idGenBank_Entry` INT NOT NULL ,
  INDEX `fk_taxonomy_GenBank_Entry1_idx` (`GenBank_Entry_idGenBank_Entry` ASC) ,
  CONSTRAINT `fk_taxonomy_GenBank_Entry1`
    FOREIGN KEY (`GenBank_Entry_idGenBank_Entry` )
    REFERENCES `mydb`.`GenBank_Entry` (`idGenBank_Entry` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`qualifiers`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `mydb`.`qualifiers` (
  `idqualifiers` INT NOT NULL ,
  `features_id` VARCHAR(45) NOT NULL ,
  `key` VARCHAR(45) NULL ,
  `value` VARCHAR(45) NULL ,
  PRIMARY KEY (`idqualifiers`) ,
  INDEX `fk_qualifiers_features1_idx` (`features_id` ASC) ,
  CONSTRAINT `fk_qualifiers_features1`
    FOREIGN KEY (`features_id` )
    REFERENCES `mydb`.`features` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `mydb` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
