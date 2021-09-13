INSERT INTO `addon_account` (name, label, shared) VALUES
    ('society_burgershot', 'Burgershot', 1)
;

INSERT INTO `addon_account_data` (id, account_name, money, owner) VALUES
    (0, 'society_burgershot', 0, 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
    ('society_burgershot', 'Burgershot', 1)
;

INSERT INTO `jobs` (name, label) VALUES
    ('burgershot', 'Burgershot')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
    ('burgershot',0,'employee','Employee',12,'{}','{}'),
    ('burgershot',1,'assistant','Assistant',24,'{}','{}'),
    ('burgershot',2,'boss','Boss',36,'{}','{}');
;