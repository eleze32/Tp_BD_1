create schema CompraTP;
use CompraTp;

create table cliente (
	cuit varchar(13) primary key,
	razon_social varchar(50),
	mail varchar(50),
	domicilio varchar(200)
);

create table proveedor (
	cuit varchar(13) primary key,
	razon_social varchar(50),
	domicilio varchar(200),
	pais_origen varchar (50),
    tel varchar(30)	
);

create table rubro(
     codigo int primary key,
     nombre varchar(15)
);

create table compra(
	codigo int  primary key,
	finalizada char(2),
	cuit_cliente varchar(13) ,
	foreign key (cuit_cliente) references cliente(cuit) on delete set null on update cascade
);

create table factura(
	codigo int primary key,
	f_pago date ,
	f_vencimiento date,
	codigo_compra int ,
	foreign key (codigo_compra) references compra (codigo) on delete restrict on update restrict 
);


create table producto (
	codigo int primary key,
	nombre varchar(50),
	preciounidad decimal(6,2),
	cuit_proveedor varchar(13),
	codigo_rubro int, 
	foreign key (cuit_proveedor) references proveedor(cuit) on delete set null on update cascade,
    foreign key (codigo_rubro) references rubro(id) on delete set null on update cascade
);

create table renglon (
	id int,
	codigo_factura int,
    codigo_producto int,
    cantidad int,
    primary key(id,codigo_factura,codigo_producto),
    foreign key (codigo_factura) references factura(codigo) on delete restrict on update restrict,
    foreign key (codigo_producto) references producto(codigo) on update cascade
);

create table Tel_cliente( 
	cuit_cliente varchar(13),
	tel varchar(15),
    primary key(cuit_cliente,tel),
    foreign key(cuit_cliente) references cliente(cuit) on delete cascade on update cascade
);

create table medio_pago_factura(
      codigo_factura int,
      medio_pago varchar(10),
      primary key(codigo_factura,medio_pago),
      foreign key(codigo_factura) references factura(codigo) on delete cascade on update restrict
);


insert into cliente values('30-30234541-7','La Razon S.A','info@larazonsa.com.ar','Bucarest 3045'),
                          ('30-30235452-2','Gfast S.A','gfast@gfastsa.com.ar','Sanche de Bustamante 1234'),
                          ('30-23212343-5','Indi S.A','infoindi@indisa.com.ar','Luis maria Campo 8'),
                          ('30-24543432-9','Cps Comunicaciobes S.A','metrotel@metrotel.com.ar','Aconcagua 2045'),  
                          ('30-31222254-1','Warner Bross S.A','info@warnerbross.com','Avenida Corrientes 3425'),
                          ('30-23456456-6','La Libeluda S.A','info@lalibelulasa.com','Avenida Corrientes 5674'),
                          ('30-12347654-2','Pepito S.R.L','info@pepitosrl.com','Avenida Libertador 666');
                             
insert into proveedor values('30-23323223-3','Fargo S.A','Avenida Siempre Viva 123','Uruguay','00598-542-44509876'),
							('30-25565656-5','Guaymallen  S.A','Avenida Alfajor 787','Argentina','011-43452345'),
							('30-29573829-6','Arcor S.A','Avenida Concejal Roca 2567','Argentina','011-35345434');

insert into rubro values (1,'Alimento'),(2,'Golosinas'),(3,'Bebidas'),(4,'Comestibles');
                          	

insert into compra values (1,'no','30-30234541-7'),
						  (2,'si','30-23212343-5'),
						  (3,'si','30-24543432-9'),
						  (4,'no','30-12347654-2'),
						  (5,'si','30-31222254-1');

insert into factura values  (1,'2014-11-23','2014-12-30',4),
							(2,'2014-11-24','2015-01-05',3),
							(3,'2014-12-05','2015-01-10',1),
							(4,'2014-12-15','2015-01-22',2),
							(5,'2014-12-23','2014-02-01',5);

insert into producto values (232,'Mermeladin',20.35,'30-29573829-6',1),
							(159,'Pansito',50.34,'30-23323223-3',4),
							(666,'Alfajorsito',40.23,'30-25565656-5',2),
							(589,'Budinsito',25.6,'30-23323223-3',4),
							(669,'Tortitas',40.25,'30-23323223-3',4),
							(345,'Caramelitos',12.45,'30-29573829-6',2),
							(876,'Donitas',15.15,'30-25565656-5',1),
							(239,'Jugos Tang',5,'30-29573829-6',3),
							(245,'Agua Villa del Sur',20,'30-29573829-6',3), 
							(360,'Jugo Levite Pera',15,'30-29573829-6',3),              
                            (259,'Jugo aquarius Manzana',12.45,'30-29573829-6',3);

insert into renglon values (1,1,232,3),(2,1,669,6),(3,1,876,10),
						   (1,2,159,30),(2,2,232,6),(3,2,589,21),(4,2,345,49),
						   (1,3,666,41),(2,3,345,52),(3,3,159,31),(4,3,669,61),
						   (1,4,669,21),(2,4,876,24),(3,4,159,23),
						   (1,5,666,65),(2,5,345,81),(3,5,876,39),(4,5,669,74);
						   
insert into medio_pago_factura values(1,'tarjeta'),
									 (2,'efectivo'),
									 (3,'cheque'),
									 (4,'tarjeta'),
									 (5,'efectivo'),
									 (2,'cheque');


insert into tel_cliente values ('30-30234541-7','011-23459883'),
                               ('30-30234541-7','011-23459702'),
                               ('30-30235452-2','0220-2345678'),
							   ('30-23212343-5','011-54342345'),
                               ('30-24543432-9','0291-63802051'),
							   ('30-24543432-9','0291-63802052'),
                               ('30-24543432-9','0237-44345678'),
                               ('30-31222254-1','011-1523456784'),
                               ('30-23456456-6','011-23233232'),
                               ('30-12347654-2','02202-44503443'),
							   ('30-12347654-2','02202-44503433');
					
                                 
/* 1- Obtener el total gastado por cada cliente en cada factura */

select c.razon_social,sum(r.cantidad * p.preciounidad)
from (((cliente c left join compra cm on c.cuit = cm.cuit_cliente) 
inner join factura f on cm.codigo = f.codigo_compra)
inner join renglon r on f.codigo = r.codigo_factura) 
inner join producto p on p.codigo = r.codigo_producto 
group by r.codigo_factura;


/* 2- Obtener el cliente con mayor monto gastado, debe figurar razon social, numero de compra y codigo */

select c.razon_social as Cliente, cm.codigo as Numerodecompra,sum(r.cantidad * p.preciounidad) as Monto
from (((cliente c inner join compra cm on c.cuit = cm.cuit_cliente) 
inner join factura f on f.codigo_compra = cm.codigo) 
inner join renglon r on r.codigo_factura = f.codigo) 
inner join producto p on p.codigo = r.codigo_producto
group by r.codigo_factura
having Monto = ( select max(totales.total) from
( select sum(r.cantidad * p.preciounidad)  as total
from (((cliente c inner join compra cm on c.cuit = cm.cuit_cliente) 
inner join factura f on f.codigo_compra = cm.codigo) 
inner join renglon r on r.codigo_factura = f.codigo) 
inner join producto p on p.codigo = r.codigo_producto
group by r.codigo_factura) as totales );

/* 3- Obtener el cliente con menor monto gastado, debe figurar razon social, numero de compra y codigo */

select c.razon_social as Cliente, cm.codigo as Numerodecompra,sum(r.cantidad * p.preciounidad) as Monto
from (((cliente c inner join compra cm on c.cuit = cm.cuit_cliente) 
inner join factura f on f.codigo_compra = cm.codigo) 
inner join renglon r on r.codigo_factura = f.codigo) 
inner join producto p on p.codigo = r.codigo_producto
group by r.codigo_factura
having Monto = ( select min(totales.total) from
( select sum(r.cantidad * p.preciounidad)  as total
from (((cliente c inner join compra cm on c.cuit = cm.cuit_cliente) 
inner join factura f on f.codigo_compra = cm.codigo) 
inner join renglon r on r.codigo_factura = f.codigo) 
inner join producto p on p.codigo = r.codigo_producto
group by r.codigo_factura) as totales );

/* 4- Listar codigo, nombre y cantidad del producto mas vendido */

select p.codigo as CodigoProducto, p.Nombre as Nombre, sum(r.cantidad) as Cantidad
from   producto p left join renglon r on r.codigo_producto = p.codigo
group by r.codigo_producto
having sum(r.cantidad) = ( select max(totales.total) from
( select sum(r.cantidad) as total
from   producto p left join renglon r on r.codigo_producto = p.codigo
group by r.codigo_producto ) as totales );

/* 5 -Listar nombre de cliente, Domicilio, Numero de compra, numero de factura, 
   de cliente con compras mayor a $3000 */

select c.razon_social as Cliente ,c.domicilio as Domicilio, cm.codigo as Compra, 
       f.codigo as NumeroFactura,sum(r.cantidad * p.preciounidad)  as Monto
from (((cliente c inner join compra cm on c.cuit = cm.cuit_cliente) 
inner join factura f on f.codigo_compra = cm.codigo) 
inner join renglon r on r.codigo_factura = f.codigo) 
inner join producto p on p.codigo = r.codigo_producto
group by r.codigo_factura
having sum(r.cantidad * p.preciounidad) > 3000;

/* 6- Listar cantidad de prodcuto que vendio cada proveedor */

select pr.razon_social as RazonSocial, sum(cantidad) as Cantidad
from (proveedor pr left join producto p on p.cuit_proveedor = pr.cuit) 
inner join renglon r on r.codigo_producto = p.codigo
group by pr.razon_social;


/* 7- Listar proveedor que vendio menos productos, indicando razon social y cantidad de productos vendidos */

select pr.razon_social as Proveedor, sum(cantidad) as Cantidad
from (proveedor pr left join producto p on p.cuit_proveedor = pr.cuit) 
inner join renglon r on r.codigo_producto = p.codigo
group by pr.razon_social
having sum(cantidad) = ( select min(totales.total) 
from
(select sum(cantidad) as total
from (proveedor pr left join producto p on p.cuit_proveedor = pr.cuit) 
inner join renglon r on r.codigo_producto = p.codigo
group by pr.razon_social) as Totales );


/* 8- Listar las compras no finalizadas, indicando a que cliente pertenece, su domicilio y el numero de compra */

select c.razon_social as Cliente, c.domicilio as Domicilio, cm.codigo as NumeroDeCompra
from cliente c inner join compra cm on c.cuit = cm.cuit_cliente and cm.finalizada = 'no';

/* 9- El cliente 30-12347654-2 finalizo su compra */

Update compra 
set  finalizada = 'si'
where cuit_cliente = '30-12347654-2';

/* 10- Se verifica que la compra 1 ah sido saldada */

Update compra 
set  finalizada = 'si'
where codigo = 1;


/* 11- Se verifica que la empresa ya no seguira vendiendo producto con rubro Bebidas. */

delete from producto
where codigo_rubro = ( select codigo from rubro 
				   where nombre = 'Bebidas'
                 );


