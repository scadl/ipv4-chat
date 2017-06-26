unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdSocketHandle, Vcl.StdCtrls,
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPServer, IdGlobal, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    IdUDPServer1: TIdUDPServer;
    Memo1: TMemo;
    TrayIcon1: TTrayIcon;
    Timer1: TTimer;
    procedure IdUDPServer1UDPRead(AThread: TIdUDPListenerThread;
      const AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure FormHide(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  clients: tstringlist;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
clients:=TStringList.Create;
end;

procedure TForm1.FormHide(Sender: TObject);
begin
TrayIcon1.Visible:=true;
end;

procedure TForm1.IdUDPServer1UDPRead(AThread: TIdUDPListenerThread;
  const AData: TIdBytes; ABinding: TIdSocketHandle);
  var
    ssm: TStringStream;
    i: integer;
    com: integer;
    rq: tstringlist;
    arid: TIDBytes;
begin
  ssm:=TStringStream.Create( BytesToString(adata) );
  rq:=TStringList.Create;
  rq.StrictDelimiter:=true;
  rq.Delimiter:='|';
  rq.DelimitedText:=ssm.DataString;
  i:=0;



  //sst:='';
  //ssm.CopyFrom(adata, adata.Size);

    {
  try
     com:=strtoint(ssm.DataString)
  except
     //showMessage('unconvertable');
     com:=0;
  end;
     }

   //Move(rq.Text[1], arid, length(rq.text));


  case strtoint(rq[0]) of
  1:
  begin
    clients.Add(ABinding.PeerIP);
    memo1.Lines.Add('Connected NEW client: '+ABinding.PeerIP+':'+inttostr(ABinding.PeerPort)+' as "'+rq[1]+'"');
    //ABinding.SendTo(ABinding.PeerIP, IdUDPServer1.DefaultPort+1, RawToBytes(clients.Text[1], Length(clients.Text)), ID_DEFAULT_IP_VERSION);
  end;
  2:
  begin
    clients.Delete(clients.IndexOf(ABinding.PeerIP));
    memo1.Lines.Add('DISconnected client: '+ABinding.PeerIP+':'+inttostr(ABinding.PeerPort)+' as "'+rq[1]+'"');
  end;
  3:
  begin
    memo1.Lines.Add(ABinding.PeerIP+': '+inttostr(ABinding.PeerPort)+' '+ssm.DataString);
  end;
  end;

   for I := 0 to clients.Count do
   begin
      ABinding.SendTo(clients[i], IdUDPServer1.DefaultPort+1, adata, ID_DEFAULT_IP_VERSION);
   end;

  //memo1.Lines.Add(inttostr(strtoint(ssm.DataString)));
  //ABinding.Send(adata);
  ssm.Free;

  {
   ShowMessage(inttostr(SizeOf(arid)));
   arid:=RawToBytes(clients.Text[1], Length(clients.Text));
   ShowMessage(inttostr(SizeOf(arid)));
   }

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
if form1.WindowState=wsMinimized
then begin
  TrayIcon1.Visible:=true;
  form1.Hide;
end else begin
  TrayIcon1.Visible:=false;
end;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
form1.Show;
form1.WindowState:=wsNormal;
TrayIcon1.Visible:=false;
end;

end.
