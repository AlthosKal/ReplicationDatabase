CREATE TYPE state AS ENUM('active', 'inactive', 'suspended');
CREATE TYPE accountType  AS ENUM('individual', 'business');
CREATE TYPE stateInvestment AS ENUM('active', 'inactive', 'suspended', 'finalized', 'canceled');
CREATE TYPE stateDebt AS ENUM('active','paid', 'defeated', 'refinanced', 'in moratorium', 'canceled');

CREATE TABLE IF NOT EXISTS  KuenteCOUser (
    id UUID DEFAULT gen_random_uuid(),
    CONSTRAINT PK_id_User PRIMARY KEY (id),
    email VARCHAR(50) NOT NULL ,
    password VARCHAR(160) NOT NULL ,
    registerDate TIMESTAMP DEFAULT now() NOT NULL,
    account state DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS Account (
    id SERIAL,
    CONSTRAINT PK_id_Account PRIMARY KEY (id),
    idUser UUID,
    type accountType DEFAULT 'individual',
    balance NUMERIC DEFAULT 0,
    currency VARCHAR(10),
    startDate TIMESTAMP DEFAULT now() NOT NULL,
    CONSTRAINT FK_Account_User FOREIGN KEY (idUser)
        REFERENCES KuenteCOUser (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Subscription (
    id SERIAL,
    CONSTRAINT PK_id_Subscription PRIMARY KEY (id),
    idUser UUID,
    type VARCHAR(50) NOT NULL,
    startDate TIMESTAMP DEFAULT now() NOT NULL ,
    expirationDate TIMESTAMP NOT NULL,
    state state DEFAULT 'inactive',
    CONSTRAINT FK_Subscription_User FOREIGN KEY (idUser)
        REFERENCES KuenteCOUser (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS PaySubscription (
    id SERIAL,
    CONSTRAINT PK_id_PaySubscription PRIMARY KEY (id),
    idSubscription INTEGER,
    amount NUMERIC,
    payDate TIMESTAMP DEFAULT now() NOT NULL,
    CONSTRAINT FK_PaySubscription_Subscription FOREIGN KEY (idSubscription)
        REFERENCES Subscription (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS PaytMethod (
    id SERIAL,
    CONSTRAINT PK_id_PayMethod PRIMARY KEY (id),
    type VARCHAR(50),
    idPaySuscription INTEGER,
    CONSTRAINT FK_PayMethod_PaySubscription FOREIGN KEY (idPaySuscription)
    REFERENCES PaySubscription (id)
    ON UPDATE RESTRICT
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS PaymetHistory (
    id SERIAL,
    CONSTRAINT PK_id_PaymentHistory PRIMARY KEY (id),
    idPaySubscription INTEGER,
    details JSONB,
    CONSTRAINT FK_PaymentHistory_PaySubscription FOREIGN KEY (idPaySubscription)
        REFERENCES PaySubscription (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Budget (
    id SERIAL,
    CONSTRAINT PK_id_Budget PRIMARY KEY (id),
    idUser UUID,
    name VARCHAR(100),
    description VARCHAR(255),
    assignedAmount NUMERIC NOT NULL,
    startDate TIMESTAMP DEFAULT now() NOT NULL ,
    finishDate TIMESTAMP NOT NULL,
    state state DEFAULT 'active',
    CONSTRAINT FK_Budget_User FOREIGN KEY (idUser)
        REFERENCES KuenteCOUser (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Category (
    id SERIAL,
    CONSTRAINT PK_idCategory PRIMARY KEY (id),
    idUser UUID,
    name VARCHAR(50),
    description JSONB,
    assignedBudget NUMERIC,
    startDate TIMESTAMP DEFAULT now() NOT NULL,
    finishDate TIMESTAMP NOT NULL,
    state state DEFAULT 'active',
    CONSTRAINT FK_Category_User FOREIGN KEY (idUser)
        REFERENCES KuenteCOUser (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Transaction
(
    id SERIAL,
    CONSTRAINT PK_id_Transaction PRIMARY KEY (id),
    idAccount INTEGER,
    idCategory INTEGER,
    type VARCHAR(50),
    amount NUMERIC,
    transactionDate TIMESTAMP DEFAULT now() NOT NULL,
    description JSONB,
    CONSTRAINT FK_Transaction_Account FOREIGN KEY (idAccount)
        REFERENCES Account (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE,
    CONSTRAINT FK_Transaction_Category FOREIGN KEY (idCategory)
        REFERENCES Category (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Investment (
    id SERIAL,
    CONSTRAINT PK_id_Investment PRIMARY KEY (id),
    idUser UUID,
    type VARCHAR(50),
    initialAmount NUMERIC,
    profitability NUMERIC,
    startDate TIMESTAMP DEFAULT now() NOT NULL,
    state stateInvestment DEFAULT 'active',
    CONSTRAINT FK_Investment_User FOREIGN KEY (idUser)
        REFERENCES KuenteCOUser (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Debt (
    id SERIAL,
    CONSTRAINT PK_id_Debt PRIMARY KEY (id),
    idUser UUID,
    name VARCHAR(50),
    totalAmount NUMERIC,
    pendingAmount NUMERIC,
    startDate TIMESTAMP DEFAULT now() NOT NULL,
    expirationDate TIMESTAMP NOT NULL,
    state stateDebt DEFAULT 'active',
    CONSTRAINT FK_Debt_User FOREIGN KEY (idUser)
        REFERENCES KuenteCOUser (id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Notification (
    id SERIAL,
    CONSTRAINT PK_id_Notification PRIMARY KEY (id),
    idUser UUID,
    dateSend TIMESTAMP DEFAULT now() NOT NULL,
    content JSONB,
    CONSTRAINT FK_Notification_User FOREIGN KEY (idUser)
        REFERENCES KuenteCOUser (id)
        ON UPDATE RESTRICT
);