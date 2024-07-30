//------------------------------------------------------------------------------------------------------------
//********* Sobre ************
//Autor: Gisele de Melo
//Esse código foi desenvolvido com o intuito de aprendizado para o blog codedelphi.com, portanto não me
//responsabilizo pelo uso do mesmo.
//
//********* About ************
//Author: Gisele de Melo
//This code was developed for learning purposes for the codedelphi.com blog, therefore I am not responsible for
//its use.
//------------------------------------------------------------------------------------------------------------
unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm1 = class(TForm)
    FDConnection1: TFDConnection;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure LoadCustomers;
    procedure AddCustomer(CustomerID, CompanyName, ContactName : String);
    procedure LoadCustomerOrders(CustomerID: String);
    procedure SetupConnection;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.SetupConnection;
begin
  //Driver de conexão
  FDConnection1.Params.DriverID := 'SQLite';
  //Caminho do banco de dados
  FDConnection1.Params.Database := 'C:\Users\Public\Documents\Embarcadero\Studio\22.0\Samples\data\FDDemo.sdb';
  //Habilita a conexão
  FDConnection1.Connected := True;
end;

procedure TForm1.LoadCustomers;
var
  FDQuery: TFDQuery;

begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection1;
    FDQuery.SQL.Text := 'SELECT * FROM Customers';
    FDQuery.Open;

    ListBox1.Clear;
    ListBox1.Items.Add('Código  Nome do Contato');  //Formata o título a ser exibido de acordo com os dados
    while not FDQuery.Eof do
      begin
        //Alimenta o listbox com os dados consultados
        ListBox1.Items.Add(FDQuery.FieldByName('CustomerID').AsString + ' - ' +FDQuery.FieldByName('ContactName').AsString);
        FDQuery.Next;
      end;

  finally
    FDQuery.Free;
  end;
end;

procedure TForm1.AddCustomer(CustomerID, CompanyName, ContactName : String);
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection1;
    FDQuery.SQL.Text := 'INSERT INTO Customers (CustomerID, CompanyName, ContactName) ' +
                        'VALUES (:CustomerID, :CompanyName, :ContactName)';
    FDQuery.ParamByName('CustomerID').AsString := CustomerID;
    FDQuery.ParamByName('CompanyName').AsString := ContactName;
    FDQuery.ParamByName('ContactName').AsString := ContactName;
    FDQuery.ExecSQL;

    ShowMessage('O cliente '+ ContactName + ' foi inserido.');

    LoadCustomers;//Consulta para exibir o cliente que acabou de ser inserido

  finally
    FDQuery.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  CustomerID, CompanyName, ContactName: String;

begin

  CustomerID  := InputBox('Informe o Código do Cliente, sem repetir.','','');

  if CustomerID.IsEmpty then
    Exit;

  CompanyName := InputBox('Informe o Nome da Companhia ','','');

  if CompanyName.IsEmpty then
    Exit;

  ContactName := InputBox('Informe o Nome do Contato','','');

  if ContactName.IsEmpty then
    Exit;

  //Insere o cliente
  AddCustomer(UpperCase(CustomerID), CompanyName, ContactName);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  CustomerID : String;
begin
  CustomerID := InputBox('Informe o Código:','','');
  LoadCustomerOrders(UpperCase(CustomerID));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  LoadCustomers;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetupConnection;
end;

procedure TForm1.LoadCustomerOrders(CustomerID: String);
var
  FDQuery: TFDQuery;

  //procedimento para formatar o título que será exibido de acordo com os dados
  procedure InserirTitulo(ListBox : TListBox);
  var
    Titulo : String;
    i: Integer;
  begin
    Titulo := 'Data         Estabelecimento ';
    for i := 0 to Length(FDQuery.FieldByName('ShipName').AsString) - 14 do
      Insert(' ', Titulo, 29);
    Titulo := Titulo + 'Nome do Contato';
    ListBox.Items.Add(Titulo);
  end;

begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection1;
    FDQuery.SQL.Text := 'SELECT Orders.OrderID, Orders.OrderDate, Orders.ShipName, Customers.ContactName ' +
                        'FROM Orders ' +
                        'INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID ' +
                        'WHERE Orders.CustomerID = :CustomerID';
    FDQuery.ParamByName('CustomerID').AsString := CustomerID;
    FDQuery.Open;

    ListBox1.Clear;
    InserirTitulo(ListBox1);
    while not FDQuery.Eof do
      begin
        //Alimenta o listbox com os dados consultados
        ListBox1.Items.Add(FDQuery.FieldByName('OrderDate').AsString + ' - ' + FDQuery.FieldByName('ShipName').AsString +' - '+ FDQuery.FieldByName('ContactName').AsString);
        FDQuery.Next;
      end;

  finally
    FDQuery.Free;
  end;
end;

end.
