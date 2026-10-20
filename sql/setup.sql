-- TFT Team Builder: creates BOTH databases. Import in phpMyAdmin (Import tab, no database selected).

CREATE DATABASE IF NOT EXISTS tft_champions CHARACTER SET utf8mb4;
CREATE DATABASE IF NOT EXISTS tft_comps CHARACTER SET utf8mb4;

USE tft_champions;
CREATE TABLE IF NOT EXISTS champions (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(40) NOT NULL UNIQUE);
CREATE TABLE IF NOT EXISTS traits (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(40) NOT NULL UNIQUE, type ENUM('class','origin') NOT NULL);
CREATE TABLE IF NOT EXISTS champion_traits (champion_id INT NOT NULL, trait_id INT NOT NULL, PRIMARY KEY (champion_id, trait_id),
  FOREIGN KEY (champion_id) REFERENCES champions(id) ON DELETE CASCADE, FOREIGN KEY (trait_id) REFERENCES traits(id) ON DELETE CASCADE);

INSERT IGNORE INTO champions (name) VALUES ('Akali'), ('Ambessa'), ('Amumu'), ('Blitzcrank'), ('Caitlyn'), ('Camille'), ('Cassiopeia'), ('Corki'), ('Darius'), ('Draven'), ('DrMundo'), ('Ekko'), ('Elise'), ('Ezreal'), ('Gangplank'), ('Garen'), ('Heimerdinger'), ('Illaoi'), ('Irelia'), ('Jayce'), ('Jinx'), ('KogMaw'), ('LeBlanc'), ('Leona'), ('Loris'), ('Lux'), ('Maddie'), ('Malzahar'), ('Mordekaiser'), ('Morgana'), ('Nami'), ('Nocturne'), ('NunuWillump'), ('Powder'), ('Rell'), ('RenataGlasc'), ('Renni'), ('Rumble'), ('Scar'), ('Sett'), ('Sevika'), ('Silco'), ('Singed'), ('Smeech'), ('Steb'), ('Swain'), ('Tristana'), ('Trundle'), ('TwistedFate'), ('Twitch'), ('Urgot'), ('Vander'), ('Vex'), ('Vi'), ('Violet'), ('Vladimir'), ('Zeri'), ('Ziggs'), ('Zoe'), ('Zyra');
INSERT IGNORE INTO traits (name, type) VALUES ('Ambusher','class'), ('Artillerist','class'), ('Bruiser','class'), ('Dominator','class'), ('Form Swapper','class'), ('Pit Fighter','class'), ('Quickstriker','class'), ('Sentinel','class'), ('Sniper','class'), ('Sorcerer','class'), ('Visionary','class'), ('Watcher','class'), ('Academy','origin'), ('Automata','origin'), ('Black Rose','origin'), ('Chem-Baron','origin'), ('Conqueror','origin'), ('Emissary','origin'), ('Enforcer','origin'), ('Experiment','origin'), ('Family','origin'), ('Firelight','origin'), ('High-Roller','origin'), ('Junker King','origin'), ('Rebel','origin'), ('Scrap','origin');

INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Ambusher' WHERE c.name IN ('Camille', 'Ekko', 'Jinx', 'Powder', 'Smeech');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Artillerist' WHERE c.name IN ('Corki', 'Ezreal', 'Tristana', 'Urgot');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Bruiser' WHERE c.name IN ('Elise', 'NunuWillump', 'Renni', 'Sett', 'Steb', 'Trundle');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Dominator' WHERE c.name IN ('Blitzcrank', 'Cassiopeia', 'DrMundo', 'Mordekaiser', 'Silco', 'Ziggs');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Form Swapper' WHERE c.name IN ('Elise', 'Gangplank', 'Jayce', 'Swain');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Pit Fighter' WHERE c.name IN ('Draven', 'Gangplank', 'Sevika', 'Urgot', 'Vi', 'Violet');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Quickstriker' WHERE c.name IN ('Akali', 'Ambessa', 'Nocturne', 'TwistedFate');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Sentinel' WHERE c.name IN ('Illaoi', 'Irelia', 'Leona', 'Loris', 'Rell', 'Rumble', 'Singed');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Sniper' WHERE c.name IN ('Caitlyn', 'KogMaw', 'Maddie', 'Twitch', 'Zeri');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Sorcerer' WHERE c.name IN ('LeBlanc', 'Lux', 'Nami', 'Swain', 'Vladimir', 'Zoe', 'Zyra');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Visionary' WHERE c.name IN ('Heimerdinger', 'Malzahar', 'Morgana', 'NunuWillump', 'Rell', 'RenataGlasc', 'Vex');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Watcher' WHERE c.name IN ('Amumu', 'Darius', 'Garen', 'Scar', 'Vander', 'Vladimir');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Academy' WHERE c.name IN ('Ezreal', 'Heimerdinger', 'Jayce', 'Leona', 'Lux');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Automata' WHERE c.name IN ('Amumu', 'Blitzcrank', 'KogMaw', 'Malzahar', 'Nocturne');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Black Rose' WHERE c.name IN ('Cassiopeia', 'Elise', 'LeBlanc', 'Morgana', 'Vladimir');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Chem-Baron' WHERE c.name IN ('RenataGlasc', 'Renni', 'Sevika', 'Silco', 'Singed', 'Smeech');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Conqueror' WHERE c.name IN ('Ambessa', 'Darius', 'Draven', 'Mordekaiser', 'Rell', 'Swain');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Emissary' WHERE c.name IN ('Ambessa', 'Garen', 'Nami', 'Tristana');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Enforcer' WHERE c.name IN ('Caitlyn', 'Camille', 'Loris', 'Maddie', 'Steb', 'TwistedFate', 'Vi');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Experiment' WHERE c.name IN ('DrMundo', 'NunuWillump', 'Twitch', 'Urgot', 'Zyra');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Family' WHERE c.name IN ('Powder', 'Vander', 'Violet');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Firelight' WHERE c.name IN ('Ekko', 'Scar', 'Zeri');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='High-Roller' WHERE c.name IN ('Sevika');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Junker King' WHERE c.name IN ('Rumble');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Rebel' WHERE c.name IN ('Akali', 'Ezreal', 'Illaoi', 'Irelia', 'Jinx', 'Sett', 'Vex', 'Zoe');
INSERT IGNORE INTO champion_traits SELECT c.id, t.id FROM champions c JOIN traits t ON t.name='Scrap' WHERE c.name IN ('Corki', 'Ekko', 'Gangplank', 'Powder', 'Rumble', 'Trundle', 'Ziggs');

USE tft_comps;
CREATE TABLE IF NOT EXISTS comps (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(60) NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
-- champion_name matches champions.name in the other database (no cross-database foreign key).
CREATE TABLE IF NOT EXISTS comp_champions (comp_id INT NOT NULL, champion_name VARCHAR(40) NOT NULL, PRIMARY KEY (comp_id, champion_name),
  FOREIGN KEY (comp_id) REFERENCES comps(id) ON DELETE CASCADE);
