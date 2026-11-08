object Form1: TForm1
  Left = 0
  Top = 0
  Caption =
    'Jeremia Christ Immanuel Manalu - 5023231017 - Spherical Pendulum' +
    ' Simulator (Lagrange and Hamilton)'
  ClientHeight = 760
  ClientWidth = 1280
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 1000
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 300
    Height = 760
    Align = alLeft
    BevelOuter = bvNone
    Padding.Left = 8
    Padding.Top = 8
    Padding.Right = 8
    Padding.Bottom = 8
    TabOrder = 0
    object lblParams: TLabel
      Left = 8
      Top = 8
      Width = 284
      Height = 15
      Align = alTop
      Caption = 'Preset, parameters and initial state'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblResults: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 324
      Width = 284
      Height = 15
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 0
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Results'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cbPreset: TComboBox
      AlignWithMargins = True
      Left = 8
      Top = 27
      Width = 284
      Height = 23
      Margins.Left = 0
      Margins.Top = 4
      Margins.Right = 0
      Margins.Bottom = 4
      Align = alTop
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'General motion (alpha0 = 60 deg, phidot0 = 1 rad/s)'
      OnChange = cbPresetChange
      Items.Strings = (
        'General motion (alpha0 = 60 deg, phidot0 = 1 rad/s)'
        'Planar pendulum, small angle (alpha0 = 10 deg)'
        'Planar pendulum, large angle (alpha0 = 90 deg)'
        'Conical pendulum (alpha0 = 30 deg, phidot0 = Omega)')
    end
    object vleParams: TValueListEditor
      Left = 8
      Top = 54
      Width = 284
      Height = 222
      Align = alTop
      Strings.Strings = (
        'Mass m (kg)=1'
        'Link length l (m)=1'
        'Gravity g (m/s2)=9.81'
        'Start angle alpha0 (deg)=60'
        'Polar rate thetadot0 (rad/s)=0'
        'Azimuthal rate phidot0 (rad/s)=1'
        'Time step dt (s)=0.001'
        'Simulation time (s)=20')
      TabOrder = 1
      TitleCaptions.Strings = (
        'Parameter'
        'Value')
      ColWidths = (
        190
        88)
    end
    object pnlButtons: TPanel
      Left = 8
      Top = 276
      Width = 284
      Height = 40
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object btnRun: TButton
        Left = 0
        Top = 6
        Width = 90
        Height = 30
        Caption = 'Run (F5)'
        TabOrder = 0
        OnClick = btnRunClick
      end
      object btnEquations: TButton
        Left = 96
        Top = 6
        Width = 100
        Height = 30
        Caption = 'Equations (F1)'
        TabOrder = 1
        OnClick = btnEquationsClick
      end
      object btnClear: TButton
        Left = 202
        Top = 6
        Width = 82
        Height = 30
        Caption = 'Clear'
        TabOrder = 2
        OnClick = btnClearClick
      end
    end
    object memResult: TMemo
      Left = 8
      Top = 343
      Width = 284
      Height = 409
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 3
    end
  end
  object gpCharts: TGridPanel
    Left = 300
    Top = 0
    Width = 980
    Height = 760
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = chtPosition
        Row = 0
      end
      item
        Column = 1
        Control = chtVelocity
        Row = 0
      end
      item
        Column = 0
        Control = chtMomentum
        Row = 1
      end
      item
        Column = 1
        Control = chtTopView
        Row = 1
      end>
    ParentBackground = False
    RowCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    TabOrder = 1
    object chtPosition: TChart
      Left = 0
      Top = 0
      Width = 490
      Height = 380
      BackWall.Brush.Style = bsClear
      Legend.Alignment = laBottom
      Legend.CheckBoxes = True
      Legend.Font.Color = 3355443
      Legend.Font.Height = -12
      Legend.Font.Name = 'Segoe UI'
      Legend.Frame.Visible = False
      Legend.LegendStyle = lsSeries
      Title.Font.Color = 3355443
      Title.Font.Name = 'Segoe UI'
      Title.Font.Style = [fsBold]
      Title.Text.Strings = (
        'Position: polar angle theta(t), both methods')
      BottomAxis.Grid.Color = 15132390
      BottomAxis.LabelsFormat.Font.Color = 5592405
      BottomAxis.LabelsFormat.Font.Height = -11
      BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
      BottomAxis.Title.Caption = 't (s)'
      BottomAxis.Title.Font.Color = 3355443
      BottomAxis.Title.Font.Height = -12
      BottomAxis.Title.Font.Name = 'Segoe UI'
      LeftAxis.Grid.Color = 15132390
      LeftAxis.LabelsFormat.Font.Color = 5592405
      LeftAxis.LabelsFormat.Font.Height = -11
      LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
      LeftAxis.Title.Caption = 'theta (deg)'
      LeftAxis.Title.Font.Color = 3355443
      LeftAxis.Title.Font.Height = -12
      LeftAxis.Title.Font.Name = 'Segoe UI'
      View3D = False
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 0
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object serThetaL: TFastLineSeries
        SeriesColor = 14055466
        Title = 'theta, Lagrange'
        LinePen.Width = 3
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
      object serThetaH: TFastLineSeries
        SeriesColor = 3434731
        Title = 'theta, Hamilton (dashed)'
        LinePen.Style = psDash
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
    object chtVelocity: TChart
      Left = 490
      Top = 0
      Width = 490
      Height = 380
      BackWall.Brush.Style = bsClear
      Legend.Alignment = laBottom
      Legend.CheckBoxes = True
      Legend.Font.Color = 3355443
      Legend.Font.Height = -12
      Legend.Font.Name = 'Segoe UI'
      Legend.Frame.Visible = False
      Legend.LegendStyle = lsSeries
      Title.Font.Color = 3355443
      Title.Font.Name = 'Segoe UI'
      Title.Font.Style = [fsBold]
      Title.Text.Strings = (
        'Velocity (Lagrangian method)')
      BottomAxis.Grid.Color = 15132390
      BottomAxis.LabelsFormat.Font.Color = 5592405
      BottomAxis.LabelsFormat.Font.Height = -11
      BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
      BottomAxis.Title.Caption = 't (s)'
      BottomAxis.Title.Font.Color = 3355443
      BottomAxis.Title.Font.Height = -12
      BottomAxis.Title.Font.Name = 'Segoe UI'
      LeftAxis.Grid.Color = 15132390
      LeftAxis.LabelsFormat.Font.Color = 5592405
      LeftAxis.LabelsFormat.Font.Height = -11
      LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
      LeftAxis.Title.Caption = 'angular rate (rad/s)'
      LeftAxis.Title.Font.Color = 3355443
      LeftAxis.Title.Font.Height = -12
      LeftAxis.Title.Font.Name = 'Segoe UI'
      View3D = False
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 1
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object serThetaDot: TFastLineSeries
        SeriesColor = 14055466
        Title = 'thetadot'
        LinePen.Width = 2
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
      object serPhiDot: TFastLineSeries
        SeriesColor = 3434731
        Title = 'phidot'
        LinePen.Width = 2
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
    object chtMomentum: TChart
      Left = 0
      Top = 380
      Width = 490
      Height = 380
      BackWall.Brush.Style = bsClear
      Legend.Alignment = laBottom
      Legend.CheckBoxes = True
      Legend.Font.Color = 3355443
      Legend.Font.Height = -12
      Legend.Font.Name = 'Segoe UI'
      Legend.Frame.Visible = False
      Legend.LegendStyle = lsSeries
      Title.Font.Color = 3355443
      Title.Font.Name = 'Segoe UI'
      Title.Font.Style = [fsBold]
      Title.Text.Strings = (
        'Momentum (Hamiltonian method)')
      BottomAxis.Grid.Color = 15132390
      BottomAxis.LabelsFormat.Font.Color = 5592405
      BottomAxis.LabelsFormat.Font.Height = -11
      BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
      BottomAxis.Title.Caption = 't (s)'
      BottomAxis.Title.Font.Color = 3355443
      BottomAxis.Title.Font.Height = -12
      BottomAxis.Title.Font.Name = 'Segoe UI'
      LeftAxis.Grid.Color = 15132390
      LeftAxis.LabelsFormat.Font.Color = 5592405
      LeftAxis.LabelsFormat.Font.Height = -11
      LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
      LeftAxis.Title.Caption = 'momentum (kg m2/s)'
      LeftAxis.Title.Font.Color = 3355443
      LeftAxis.Title.Font.Height = -12
      LeftAxis.Title.Font.Name = 'Segoe UI'
      View3D = False
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 2
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object serPTheta: TFastLineSeries
        SeriesColor = 14055466
        Title = 'p_theta'
        LinePen.Width = 2
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
      object serPPhi: TFastLineSeries
        SeriesColor = 3434731
        Title = 'p_phi (constant)'
        LinePen.Width = 2
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
    object chtTopView: TChart
      Left = 490
      Top = 380
      Width = 490
      Height = 380
      BackWall.Brush.Style = bsClear
      Legend.Visible = False
      Title.Font.Color = 3355443
      Title.Font.Name = 'Segoe UI'
      Title.Font.Style = [fsBold]
      Title.Text.Strings = (
        'Path of the bob seen from above (x-y)')
      BottomAxis.Grid.Color = 15132390
      BottomAxis.LabelsFormat.Font.Color = 5592405
      BottomAxis.LabelsFormat.Font.Height = -11
      BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
      BottomAxis.Title.Caption = 'x (m)'
      BottomAxis.Title.Font.Color = 3355443
      BottomAxis.Title.Font.Height = -12
      BottomAxis.Title.Font.Name = 'Segoe UI'
      LeftAxis.Grid.Color = 15132390
      LeftAxis.LabelsFormat.Font.Color = 5592405
      LeftAxis.LabelsFormat.Font.Height = -11
      LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
      LeftAxis.Title.Caption = 'y (m)'
      LeftAxis.Title.Font.Color = 3355443
      LeftAxis.Title.Font.Height = -12
      LeftAxis.Title.Font.Name = 'Segoe UI'
      View3D = False
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 3
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object serPath: TLineSeries
        SeriesColor = 8040219
        Title = 'bob path'
        Brush.BackColor = clDefault
        LinePen.Width = 2
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        Pointer.Visible = False
        XValues.Name = 'X'
        XValues.Order = loNone
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
  end
end
