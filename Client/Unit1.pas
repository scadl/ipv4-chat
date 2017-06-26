unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdSocketHandle, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, IdUDPServer, IdBaseComponent, IdComponent,
  IdUDPBase, IdUDPClient, IdGlobal, MMSystem;

type
  TForm1 = class(TForm)
    IdUDPClient1: TIdUDPClient;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    IdUDPServer1: TIdUDPServer;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    RichEdit1: TRichEdit;
    LabeledEdit3: TLabeledEdit;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    GroupBox3: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit2: TEdit;
    OpenDialog1: TOpenDialog;
    Button3: TButton;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    CheckBox3: TCheckBox;
    Edit3: TEdit;
    Button4: TButton;
    CheckBox4: TCheckBox;
    Edit4: TEdit;
    Button5: TButton;
    GroupBox4: TGroupBox;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure IdUDPServer1UDPRead(AThread: TIdUDPListenerThread;
      const AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure IdUDPClient1Connected(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  disconnect: boolean;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
if disconnect then
begin

IdUDPClient1.Send('2|'+LabeledEdit3.Text);

IdUDPClient1.BroadcastEnabled:=false;
IdUDPClient1.Active:=false;

IdUDPServer1.BroadcastEnabled:=false;
IdUDPServer1.ThreadedEvent:=false;
IdUDPServer1.Active:=false;

GroupBox2.Enabled:=false;
RichEdit1.Enabled:=false;
edit1.Enabled:=false;
Button2.Enabled:=false;
RichEdit1.Color:=clBtnFace;
edit1.Color:=clBtnFace;

LabeledEdit1.Enabled:=true;
LabeledEdit2.Enabled:=true;
LabeledEdit3.Enabled:=true;
Button1.Caption:='Connect';

disconnect:=False;
end else begin

IdUDPClient1.Host:=LabeledEdit1.Text;
IdUDPClient1.Port:=strtoint(LabeledEdit2.Text);
IdUDPClient1.BroadcastEnabled:=true;
IdUDPClient1.Active:=True;

IdUDPServer1.DefaultPort:=strtoint(LabeledEdit2.Text)+1;
IdUDPServer1.BroadcastEnabled:=true;
IdUDPServer1.ThreadedEvent:=True;
IdUDPServer1.Active:=true;

GroupBox2.Enabled:=true;
RichEdit1.Enabled:=true;
edit1.Enabled:=true;
Button2.Enabled:=true;
RichEdit1.Color:=clWindow;
edit1.Color:=clWindow;

Randomize;
if LabeledEdit3.Text='' then LabeledEdit3.Text:='User #'+inttostr(Random(99999));
LabeledEdit1.Enabled:=false;
LabeledEdit2.Enabled:=false;
LabeledEdit3.Enabled:=false;
Button1.Caption:='DISConnect';

IdUDPClient1.Send('1|'+LabeledEdit3.Text);

disconnect:=true;
end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var i:integer; encstr:string;
begin

i:=0;
encstr:='';
button2.Visible:=false;
ProgressBar1.Visible:=true;
ProgressBar1.Max:=length(edit1.Text);
Label1.Visible:=true;
for I := 1 to length(edit1.Text) do
begin
 encstr:=encstr+inttostr(ord(edit1.Text[i]))+'|';
 ProgressBar1.Position:=i;
 label1.Caption:='Encoding message: Symbol '+inttostr(i)+' of '+inttostr(length(edit1.Text));
end;

button2.Visible:=true;
ProgressBar1.Visible:=false;
Label1.Visible:=false;

IdUDPClient1.Send('3|'+LabeledEdit3.Text+': |'+encstr);

edit1.Text:='';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
if OpenDialog1.Execute then edit2.Text:=OpenDialog1.FileName;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if OpenDialog1.Execute then edit3.Text:=OpenDialog1.FileName;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
if OpenDialog1.Execute then edit4.Text:=OpenDialog1.FileName;
end;

procedure TForm1.Edit3Click(Sender: TObject);
begin
if OpenDialog1.Execute then edit3.Text:=OpenDialog1.FileName;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
IdUDPClient1.Send('2|'+LabeledEdit3.Text);

IdUDPClient1.BroadcastEnabled:=false;
IdUDPClient1.Active:=false;

IdUDPServer1.BroadcastEnabled:=false;
IdUDPServer1.ThreadedEvent:=false;
IdUDPServer1.Active:=false;
end;

procedure TForm1.FormHide(Sender: TObject);
begin
TrayIcon1.Visible:=true;
end;

procedure TForm1.IdUDPClient1Connected(Sender: TObject);
begin
GroupBox2.Enabled:=true;
RichEdit1.Enabled:=true;
edit1.Enabled:=true;
Button2.Enabled:=true;
RichEdit1.Color:=clWindow;
edit1.Color:=clWindow;
end;

procedure TForm1.IdUDPServer1UDPRead(AThread: TIdUDPListenerThread;
  const AData: TIdBytes; ABinding: TIdSocketHandle);
  var
    ssm: TStringStream;
    encstr: Tstringlist;
    i: integer;
    fstr: string;
begin
  ssm:=TStringStream.Create( BytesToString(adata) );

  encstr:=TStringList.Create;
  encstr.StrictDelimiter:=true;
  encstr.Delimiter:='|';
  encstr.DelimitedText:=ssm.DataString;



  case strtoint(encstr[0]) of
     1: begin
        RichEdit1.Lines.Add('Server: User "'+encstr[1]+'" Logged in');
        if CheckBox3.Checked then sndPlaySound(pchar(edit3.Text),0);
        if CheckBox1.Checked then begin
          TrayIcon1.BalloonHint:= 'Server: User "'+encstr[1]+'" Logged in';
          if form1.WindowState=wsMinimized then TrayIcon1.ShowBalloonHint;
        end;
        ListBox1.Items.Add(encstr[1]);
     end;
     2: begin
        RichEdit1.Lines.Add('Server: User "'+encstr[1]+'" Logged off');
        if CheckBox4.Checked then sndPlaySound(pchar(edit4.Text),0);
        if CheckBox1.Checked then begin
          TrayIcon1.BalloonHint:= 'Server: User "'+encstr[1]+'" Logged off';
          if form1.WindowState=wsMinimized then TrayIcon1.ShowBalloonHint;
        end;
        ListBox1.Items.delete(ListBox1.Items.IndexOf(encstr[1]));
     end;
     3: begin

        button2.Visible:=false;
        ProgressBar1.Visible:=true;
        ProgressBar1.Max:=encstr.Count-2;
        Label1.Visible:=true;

      for I := 2 to encstr.Count-2 do
        begin
          //showmessage('-'+encstr[i]+'-');
          fstr:=fstr+char(strtoint(encstr[i]));
          ProgressBar1.Position:=i;
          label1.Caption:='Decoding message: Symbol '+inttostr(i)+' of '+inttostr(encstr.Count-2);
        end;
      RichEdit1.Lines.Add(encstr[1]+fstr);

      button2.Visible:=true;
      ProgressBar1.Visible:=false;
      Label1.Visible:=false;

        if CheckBox2.Checked then sndPlaySound(pchar(Edit2.Text),0);
        if CheckBox1.Checked then begin
          TrayIcon1.BalloonHint:= encstr[1]+fstr;
          if form1.WindowState=wsMinimized then TrayIcon1.ShowBalloonHint;
        end;

        if ListBox1.Items.IndexOf(encstr[1])<0 then ListBox1.Items.Add(encstr[1]);

     end;

  end;

  //showmessage(ssm.DataString);

  fstr:='';
  ssm.Free;
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
