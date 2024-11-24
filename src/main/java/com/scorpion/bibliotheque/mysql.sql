CREATE TABLE cart (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    client_id BIGINT NOT NULL,
    livre_id BIGINT NOT NULL,
    quantity INT DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES client (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_livre FOREIGN KEY (livre_id) REFERENCES livre (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE favorite (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    client_id BIGINT NOT NULL,
    livre_id BIGINT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_favorite_client FOREIGN KEY (client_id) REFERENCES client (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_favorite_livre FOREIGN KEY (livre_id) REFERENCES livre (id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (client_id, livre_id)
);

CREATE TABLE adherent (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    client_id BIGINT NOT NULL,
    date_adherent DATE DEFAULT CURRENT_DATE NOT NULL,
    date_fin_adherent DATE DEFAULT DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY) NOT NULL,
    type BIGINT,
    CONSTRAINT fk_adherent_client FOREIGN KEY (client_id) REFERENCES client (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DELIMITER //

CREATE TRIGGER check_nbrEmprunt_before_insert
BEFORE INSERT ON adherent
FOR EACH ROW
BEGIN
  IF NEW.type = 1 THEN
    SET NEW.nbr_emprunt = 5;
  ELSEIF NEW.type = 2 THEN
    SET NEW.nbr_emprunt = 15;
  ELSEIF NEW.type = 3 THEN
    SET NEW.nbr_emprunt = 35; -- Exemple de valeur pour "infini"
  ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Type invalide. Les types autorisés sont 0, 1, 2.';
  END IF;
END;
//

DELIMITER ;


CREATE TABLE emprunt(
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  client_id BIGINT NOT NULL,
  livre_id BIGINT NOT NULL,
  date_emprunt DATE DEFAULT CURRENT_DATE NOT NULL,
  date_retour_prevue DATE DEFAULT DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY) NOT NULL,
  CONSTRAINT fk_emprunt_client FOREIGN KEY (client_id) REFERENCES client (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_emprunt_livre FOREIGN KEY (livre_id) REFERENCES livre (id) ON UPDATE CASCADE ON DELETE CASCADE
);