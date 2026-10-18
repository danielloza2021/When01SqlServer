/*
Ejemplo 1. Clasificar facturas por estado
Tabla :OINV
Objetivo: Convertir O = Abierta y C = Cerrada
en palabras.
*/
select DocStatus from Oinv
go

select DocNum,DocDate,DocTotal,DocStatus,
case
	when DocStatus='O' then 'Factura Abierta'
	when DocStatus='C' then 'Factura Cerrada'
	else 'Estado No Valido'
end as [Estado Factura]
from Oinv
go

/*
Ejemplo 2. Clasificar facturas por importe
tabla OINV 
Objetivo: Crear rangos de importe usando
           varias condiciones.
	DocTotal < 500 THEN 'Importe bajo'
    DocTotal < 2000 THEN 'Importe medio'
    DocTotal >= 2000 THEN 'Importe alto'
    En caso contrario'Importe no disponible'
*/
Select DocNum,DocTotal,
case
  when DocTotal<500 then 'Importe bajo'
  when DocTotal<2000 then 'Importe medio'
  when DocTotal>=2000 then 'Importe alto'
end as [Rango Importe]
from Oinv
go

/*
Ejemplo 3. Clasificar artículos por stock
tabla :OITM
Objetivo: Identificar productos sin stock,
con stock bajo o suficiente.
*/
select Stock from OITM
go

select ItemCode,ItemName,Stock,
case
  when Stock=0 then 'Sin Stock'
  when Stock BetWeen 40 and 90 then 'Stock Bajo'
  else 'Stock Suficiente'
end as [Estado Stock]
from OITM
go

/*Ejemplo 4. Clasificar clientes por línea de crédito
Tabla: OCRD 
Objetivo: Etiquetar clientes según CreditLine.
Si es Nulo se imprime: 'Sin línea registrada'
Si es Cero se imprime: 'Sin crédito'
Si es <50000 se imprime: 'Crédito pequeño'
En Caso contrario: 'Crédito amplio'
*/
select CreditLine from Ocrd
go

select CardCode,CardName,CardType,Creditline,
case
  when CreditLine is Null then 'Sin línea registrada'
  when CreditLine=0 then 'Sin crédito'
  when CreditLine<50000 then 'Crédito pequeño'
  else 'Crédito amplio'
end as [Estado Credito]
from Ocrd
go

/*Ejemplo 5. Clasificar facturas por saldo pendiente
tabla OINV 
Objetivo: Comparar el total con lo pagado.
Si DocTotal - PaidToDate <= 0 entonces 'Pagada'
Si PaidToDate = 0 entonces 'Sin pagos'
En caso contrario 'Pago parcial'
*/
select DocTotal,PaidToDate from OINV 
go

Select DocNum,DocTotal,PaidToDate,
DocTotal-PaidToDate as 
[Saldo Pendiente],
case
  when DocTotal-PaidToDate<=0 then 'Pagada'
  when PaidToDate = 0 then 'Sin pagos'
  else  'Pago Parcial'
end as [Estado Pago]
from OINV 
go

/*Ejemplo 6. Factura y nombre del cliente
Tablas: OCRD alias a, OINV alias b, 
Objetivo: Mostrar el nombre del cliente y
clasificar el importe de su factura.
Si DocTotal < 1000 entonces 'Pequeña'
Si DocTotal < 2000 entonces 'Mediana'
else 'Grande'
*/
select b.DocNum,b.DocDate,a.CardCode,
a.CardName,a.CardType,b.DocTotal,
case
  when b.DocTotal<1000 then 'Pequeña'
  when b.DocTotal<2000 then 'Mediana'
  else 'Grande'
end as [Categoria Factura]
from OCRD as a
inner join OINV as b
on (a.CardCode=b.CardCode)
go

select b.DocNum,b.DocDate,a.CardCode,
a.CardName,a.CardType,b.DocTotal,
case
  when b.DocTotal<1000 then 'Pequeña'
  when b.DocTotal<2000 then 'Mediana'
  else 'Grande'
end as [Categoria Factura]
from OCRD as a
inner join OINV as b
on (a.CardCode=b.CardCode)
where a.CardType='C'
go

/*
Ejemplo 7. Mostrar Factura y vendedor
Tablas: OSLP -- a
        OINV -- b
Objetivo: Mostrar quién atendió cada factura
y categorizarla por estado.
Si DocStatus = 'O' entonces 'Pendiente de cierre'
Si DocStatus = 'C' entonces 'Cerrada'
Sino 'Otro Estado'
*/
select b.DocEntry,b.DocNum,b.DocDate,
       a.Slpcode,a.slpName,b.DocStatus,
       case
         when b.DocStatus='O' then 'Pendiente de cierre'
         when b.DocStatus='C' then 'Cerrada'
         else 'Otro Estado'
       end as [Estado Comercial]
       from oslp as a
       inner join oinv as b
       on(a.slpCode=b.slpCode)
go

/*Ejemplo 8. Mostrar los Artículos vendidos y precio de línea
Tablas :OITM -- a
        INV1 -- b
Objetivo: Clasificar cada línea según el
importe calculado.
si LineTotal < 2500 entonces 'Línea pequeña'
si LineTotal < 4000 entonces 'Línea mediana'
sino 'Línea grande'
*/
select b.DocEntry,b.LineNum,a.ItemCode,a.ItemName,
b.Quantity,b.Price,b.LineTotal,
case
  when b.LineTotal < 2500 then 'Línea pequeña'
  when b.LineTotal < 4000  then 'Línea mediana'
  else 'Línea grande'
end as [Categoria Linea]
from OITM a inner join INV1 as b
on(a.ItemCode=b.ItemCode)

/*Ejemplo 9. Mostrar los Clientes con y sin facturas
Tablas: OCRD -- a
        OINV -- b
Objetivo: Usar LEFT JOIN y CASE para etiquetar
clientes según tengan documentos.
Si DocEntry IS NULL entonces 'Sin facturas'
sino 'Tiene facturas'
*/
select * from Ocrd
select * from Oinv
insert into Ocrd values('C0011','Tecnología Perucho',
                        'C',202,'LIMA','989876767',
                        2,9000.00,6000.00,1)

Select a.CardCode,a.CardName,b.DocEntry,b.DocNum,
case 
  when b.DocEntry is Null then 'Sin facturas'
  else 'Tiene facturas'
end as [Estado Cliente]
from Ocrd as a
left join Oinv as b
on(a.CardCode=b.CardCode)

/*Ejemplo 10. Mostrar Los Pedidos y productos
Tablas : OITM -- a
         RDR1 -- b 
Objetivo: Clasificar cantidades pedidas por línea.
Si Quantity <=2 entonces 'Cantidad pequeña'
Si Quantity <= 5 entonces 'Cantidad normal'
sino 'Cantidad grande'
con Inner Join
*/
Select b.DocEntry,a.ItemCode,a.ItemName,b.Quantity,
case
   when b.Quantity <=2 then 'Cantidad pequeña'
   when b.Quantity <=5 then 'Cantidad normal'
   else 'Cantidad grande'
end as [Categoria Cantidad]
from OITM as a
inner join RDR1 as b
on(a.ItemCode=b.ItemCode)

/*
Ejemplo 11. Mostrar Factura, cliente y vendedor
Tablas: OCRD -- a
        OINV -- b
        OSLP -- c
Objetivo: Clasificar el estado de pago e identificar
a los clientes y vendedores.
Si DocTotal - PaidToDate <= 0 entonces 'Pagada'
Si PaidToDate= 0 entonces 'Pendiente total'
sino 'Pago parcial'
Utilizar Inner Join y Left Join
*/
select b.DocNum,b.DocDate,a.CardName,c.slpName,
b.DocTotal,b.PaidToDate,
b.DocTotal-b.PaidToDate as Resultado,
case
 when b.DocTotal-b.PaidToDate <= 0 then 'Pagada'
 when b.PaidToDate = 0 then 'Pendiente total'
 else 'Pago parcial'
end as [Estado Pago]
from OCRD as a inner join OINV as b
on(a.CardCode=b.CardCode)
left Join OSLP c
on(c.SlPCode=b.SlPCode)

