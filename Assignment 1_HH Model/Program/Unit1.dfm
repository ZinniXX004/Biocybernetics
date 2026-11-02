object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 
    'Jeremia Christ Immanuel Manalu - 5023231017 - Hodgkin-Huxley Neu' +
    'ron Model Simulator'
  ClientHeight = 720
  ClientWidth = 1280
  Color = clBtnFace
  Constraints.MinHeight = 680
  Constraints.MinWidth = 1100
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  ShowHint = True
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object pnlChartTools: TPanel
    Left = 0
    Top = 0
    Width = 1280
    Height = 38
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 1278
    object lblChartHelp: TLabel
      Left = 748
      Top = 0
      Width = 440
      Height = 38
      Align = alRight
      Alignment = taRightJustify
      AutoSize = False
      Caption = 
        'Wheel: zoom | Shift+Wheel: time axis | Drag: zoom box | Right-dr' +
        'ag: pan | Double-click: reset | F5: run | F1: theory'
      EllipsisPosition = epEndEllipsis
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 740
    end
    object lblActiveChart: TLabel
      Left = 480
      Top = 0
      Width = 268
      Height = 38
      Align = alClient
      AutoSize = False
      Caption = 'Active chart: none'
      EllipsisPosition = epEndEllipsis
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 484
      ExplicitWidth = 256
    end
    object btnZoomIn: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 80
      Height = 30
      Cursor = crHandPoint
      Hint = 'Zoom the active chart in (also mouse wheel)'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 2
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Zoom in'
      Color = 15263976
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      OnClick = btnZoomInClick
    end
    object btnZoomOut: TPanel
      AlignWithMargins = True
      Left = 90
      Top = 4
      Width = 80
      Height = 30
      Cursor = crHandPoint
      Hint = 'Zoom the active chart out'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 2
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Zoom out'
      Color = 15263976
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      OnClick = btnZoomOutClick
    end
    object btnZoomReset: TPanel
      AlignWithMargins = True
      Left = 176
      Top = 4
      Width = 90
      Height = 30
      Cursor = crHandPoint
      Hint = 'Automatic axes for the active chart (also double-click)'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 2
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Reset view'
      Color = 15263976
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      OnClick = btnZoomResetClick
    end
    object btnSavePNG: TPanel
      AlignWithMargins = True
      Left = 272
      Top = 4
      Width = 100
      Height = 30
      Cursor = crHandPoint
      Hint = 'Save the active chart as a PNG image for the report'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 2
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Save PNG...'
      Color = 15263976
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 3
      OnClick = btnSavePNGClick
    end
    object btnCopyChart: TPanel
      AlignWithMargins = True
      Left = 378
      Top = 4
      Width = 100
      Height = 30
      Cursor = crHandPoint
      Hint = 'Copy the active chart to the clipboard'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 2
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Copy image'
      Color = 15263976
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 4
      OnClick = btnCopyChartClick
    end
    object btnExit: TPanel
      AlignWithMargins = True
      Left = 1192
      Top = 4
      Width = 86
      Height = 30
      Cursor = crHandPoint
      Hint = 'Close the program (Alt+F4)'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 2
      Margins.Bottom = 4
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Exit'
      Color = 2631878
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 5
      OnClick = btnExitClick
      ExplicitLeft = 1190
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 701
    Width = 1280
    Height = 19
    Panels = <
      item
        Width = 640
      end
      item
        Width = 50
      end>
    ExplicitTop = 693
    ExplicitWidth = 1278
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 38
    Width = 1280
    Height = 663
    ActivePage = tsAPG
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 1278
    ExplicitHeight = 655
    object tsAPG: TTabSheet
      Caption = '1. APG (RK4)'
      object splAPG: TSplitter
        Left = 330
        Top = 0
        Width = 5
        Height = 633
        MinSize = 260
        ResizeStyle = rsUpdate
        ExplicitHeight = 637
      end
      object pnlAPGLeft: TPanel
        Left = 0
        Top = 0
        Width = 330
        Height = 633
        Align = alLeft
        BevelOuter = bvNone
        Padding.Left = 6
        Padding.Top = 6
        Padding.Right = 6
        Padding.Bottom = 6
        TabOrder = 0
        ExplicitHeight = 625
        object rgProtocol: TRadioGroup
          Left = 6
          Top = 6
          Width = 318
          Height = 92
          Align = alTop
          Caption = ' Stimulus protocol '
          ItemIndex = 0
          Items.Strings = (
            'Step current (level from t_on to t_off)'
            'Lecturer staircase (-5/-10/-20 uA/cm2)'
            'Paired pulse (refractory test)')
          TabOrder = 0
          OnClick = rgProtocolClick
        end
        object rgMethod: TRadioGroup
          Left = 6
          Top = 98
          Width = 318
          Height = 70
          Align = alTop
          Caption = ' Integration method '
          ItemIndex = 0
          Items.Strings = (
            'Coupled RK4 on [v, m, h, n]'
            'Lecturer sequential RK4 (week-9 code)')
          TabOrder = 1
        end
        object vleAPG: TValueListEditor
          Left = 6
          Top = 168
          Width = 318
          Height = 190
          Align = alTop
          TabOrder = 2
          ColWidths = (
            150
            162)
        end
        object pnlAPGButtons: TPanel
          Left = 6
          Top = 358
          Width = 318
          Height = 40
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 3
          object btnRunAPG: TPanel
            Left = 0
            Top = 6
            Width = 112
            Height = 28
            Cursor = crHandPoint
            Hint = 'Integrate the HH equations with the selected protocol (F5)'
            BevelOuter = bvNone
            Caption = 'Run simulation'
            Color = 11694592
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            OnClick = btnRunAPGClick
          end
          object btnExportAPG: TPanel
            Left = 118
            Top = 6
            Width = 84
            Height = 28
            Cursor = crHandPoint
            Hint = 'Save t, Jin, Vm, currents, gates and conductances'
            BevelOuter = bvNone
            Caption = 'Export CSV'
            Color = 15263976
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
            OnClick = btnExportAPGClick
          end
          object btnClearAPG: TPanel
            Left = 208
            Top = 6
            Width = 52
            Height = 28
            Cursor = crHandPoint
            Hint = 'Clear the charts and results of this tab (parameters are kept)'
            BevelOuter = bvNone
            Caption = 'Clear'
            Color = 15263976
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
            OnClick = btnClearAPGClick
          end
          object btnTheoryAPG: TPanel
            Left = 266
            Top = 6
            Width = 52
            Height = 28
            Cursor = crHandPoint
            Hint = 'Open sheet 3: RK4 integration of the HH equations (F1)'
            BevelOuter = bvNone
            Caption = 'Theory'
            Color = 7043328
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 3
            OnClick = btnSheetClick
          end
        end
        object memAPG: TMemo
          Left = 6
          Top = 398
          Width = 318
          Height = 229
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 4
          WordWrap = False
          ExplicitHeight = 221
        end
      end
      object gpAPG: TGridPanel
        Left = 335
        Top = 0
        Width = 937
        Height = 633
        Align = alClient
        BevelOuter = bvNone
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
            Control = chtVm
            Row = 0
          end
          item
            Column = 1
            Control = chtCurrents
            Row = 0
          end
          item
            Column = 0
            Control = chtGates
            Row = 1
          end
          item
            Column = 1
            Control = chtConductance
            Row = 1
          end>
        RowCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        TabOrder = 1
        ExplicitWidth = 935
        ExplicitHeight = 625
        object chtVm: TChart
          Left = 0
          Top = 0
          Width = 468
          Height = 316
          Title.Text.Strings = (
            'TChart')
          Align = alClient
          TabOrder = 0
          ExplicitHeight = 312
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
        end
        object chtCurrents: TChart
          Left = 468
          Top = 0
          Width = 469
          Height = 316
          Title.Text.Strings = (
            'TChart')
          Align = alClient
          TabOrder = 1
          ExplicitWidth = 467
          ExplicitHeight = 312
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
        end
        object chtGates: TChart
          Left = 0
          Top = 316
          Width = 468
          Height = 317
          Title.Text.Strings = (
            'TChart')
          Align = alClient
          TabOrder = 2
          ExplicitTop = 312
          ExplicitHeight = 313
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
        end
        object chtConductance: TChart
          Left = 468
          Top = 316
          Width = 469
          Height = 317
          Title.Text.Strings = (
            'TChart')
          Align = alClient
          TabOrder = 3
          ExplicitTop = 312
          ExplicitWidth = 467
          ExplicitHeight = 313
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
        end
      end
    end
    object tsPhase: TTabSheet
      Caption = '2. Gating Phase Plots'
      object pnlPhaseTop: TPanel
        Left = 0
        Top = 0
        Width = 1272
        Height = 44
        Align = alTop
        BevelOuter = bvNone
        Padding.Left = 8
        Padding.Top = 4
        Padding.Right = 8
        TabOrder = 0
        object lblPhaseInfo: TLabel
          Left = 8
          Top = 4
          Width = 1060
          Height = 40
          Align = alClient
          AutoSize = False
          Caption = 
            'Trajectories of m, h and n against Vm from the last APG run (tab' +
            ' 1), one dot per time step: dense dots = slow motion, sparse dot' +
            's = fast upstroke. Grey = steady state x_inf(Vm); the loop is th' +
            'e lag of each gate behind x_inf, set by tau_x(Vm) (bottom right)' +
            '. Press F5 here to update.'
          WordWrap = True
        end
        object btnTheoryPhase: TPanel
          AlignWithMargins = True
          Left = 1080
          Top = 8
          Width = 176
          Height = 28
          Cursor = crHandPoint
          Hint = 'Open sheet 2: gating kinetics and rate constants (F1)'
          Margins.Top = 6
          Margins.Bottom = 6
          Align = alRight
          BevelOuter = bvNone
          Caption = 'Theory: gating kinetics'
          Color = 7043328
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 1
          OnClick = btnSheetClick
        end
        object btnClearPhase: TPanel
          AlignWithMargins = True
          Left = 1000
          Top = 8
          Width = 70
          Height = 28
          Cursor = crHandPoint
          Hint = 'Clear the phase plots of this tab'
          Margins.Top = 6
          Margins.Bottom = 6
          Align = alRight
          BevelOuter = bvNone
          Caption = 'Clear'
          Color = 15263976
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 3355443
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
          OnClick = btnClearPhaseClick
        end
      end
      object gpPhase: TGridPanel
        Left = 0
        Top = 44
        Width = 1272
        Height = 593
        Align = alClient
        BevelOuter = bvNone
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
            Control = chtPhaseM
            Row = 0
          end
          item
            Column = 1
            Control = chtPhaseH
            Row = 0
          end
          item
            Column = 0
            Control = chtPhaseN
            Row = 1
          end
          item
            Column = 1
            Control = chtTau
            Row = 1
          end>
        RowCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        TabOrder = 1
        object chtPhaseM: TChart
          Left = 0
          Top = 0
          Width = 636
          Height = 296
          Title.Text.Strings = (
            'TChart')
          Align = alClient
          TabOrder = 0
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
        end
        object chtPhaseH: TChart
          Left = 636
          Top = 0
          Width = 636
          Height = 296
          Title.Text.Strings = (
            'TChart')
          Align = alClient
          TabOrder = 1
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
        end
        object chtPhaseN: TChart
          Left = 0
          Top = 296
          Width = 636
          Height = 297
          Title.Text.Strings = (
            'TChart')
          Align = alClient
          TabOrder = 2
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
        end
        object chtTau: TChart
          Left = 636
          Top = 296
          Width = 636
          Height = 297
          Title.Text.Strings = (
            'TChart')
          Align = alClient
          TabOrder = 3
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
        end
      end
    end
    object tsRefractory: TTabSheet
      Caption = '3. Refractory Period'
      object splRef: TSplitter
        Left = 330
        Top = 0
        Width = 5
        Height = 637
        MinSize = 260
        ResizeStyle = rsUpdate
      end
      object pnlRefLeft: TPanel
        Left = 0
        Top = 0
        Width = 330
        Height = 637
        Align = alLeft
        BevelOuter = bvNone
        Padding.Left = 6
        Padding.Top = 6
        Padding.Right = 6
        Padding.Bottom = 6
        TabOrder = 0
        object vleRef: TValueListEditor
          Left = 6
          Top = 6
          Width = 318
          Height = 170
          Align = alTop
          TabOrder = 0
        end
        object pnlRefButtons: TPanel
          Left = 6
          Top = 176
          Width = 318
          Height = 40
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object btnRunRef: TPanel
            Left = 0
            Top = 6
            Width = 112
            Height = 28
            Cursor = crHandPoint
            Hint = 'Threshold of the test pulse for every interval (bisection, F5)'
            BevelOuter = bvNone
            Caption = 'Run sweep'
            Color = 11694592
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            OnClick = btnRunRefClick
          end
          object btnExportRef: TPanel
            Left = 118
            Top = 6
            Width = 84
            Height = 28
            Cursor = crHandPoint
            Hint = 'Save interval, threshold and second-AP peak'
            BevelOuter = bvNone
            Caption = 'Export CSV'
            Color = 15263976
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
            OnClick = btnExportRefClick
          end
          object btnClearRef: TPanel
            Left = 208
            Top = 6
            Width = 52
            Height = 28
            Cursor = crHandPoint
            Hint = 'Clear the charts and results of this tab (parameters are kept)'
            BevelOuter = bvNone
            Caption = 'Clear'
            Color = 15263976
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
            OnClick = btnClearRefClick
          end
          object btnTheoryRef: TPanel
            Left = 266
            Top = 6
            Width = 52
            Height = 28
            Cursor = crHandPoint
            Hint = 'Open sheet 6: refractory threshold and spike definitions (F1)'
            BevelOuter = bvNone
            Caption = 'Theory'
            Color = 7043328
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 3
            OnClick = btnSheetClick
          end
        end
        object pnlRefExample: TPanel
          Left = 6
          Top = 216
          Width = 318
          Height = 64
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          DesignSize = (
            318
            64)
          object lblRefInterval: TLabel
            Left = 0
            Top = 4
            Width = 183
            Height = 15
            Caption = 'Example interval (track bar): 8.0 ms'
          end
          object tbRefInterval: TTrackBar
            Left = 0
            Top = 24
            Width = 318
            Height = 34
            Hint = 'Interval between pulse onsets, 0.5 ms per step'
            Anchors = [akLeft, akTop, akRight]
            Max = 60
            Min = 2
            Frequency = 4
            Position = 16
            TabOrder = 0
            OnChange = tbRefIntervalChange
          end
        end
        object memRef: TMemo
          Left = 6
          Top = 280
          Width = 318
          Height = 347
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 3
          WordWrap = False
          ExplicitHeight = 200
        end
      end
      object gpRef: TGridPanel
        Left = 335
        Top = 0
        Width = 937
        Height = 633
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 100.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = chtRefThreshold
            Row = 0
          end
          item
            Column = 0
            Control = chtRefExample
            Row = 1
          end>
        RowCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        TabOrder = 1
        ExplicitWidth = 929
        ExplicitHeight = 637
        object chtRefThreshold: TChart
          Left = 0
          Top = 0
          Width = 929
          Height = 318
          Title.Text.Strings = (
            'TChart')
          Align = alClient
          TabOrder = 0
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
        end
        object chtRefExample: TChart
          Left = 0
          Top = 318
          Width = 929
          Height = 319
          Title.Text.Strings = (
            'TChart')
          Align = alClient
          TabOrder = 1
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
        end
      end
    end
    object tsISI: TTabSheet
      Caption = '4. C-F Converter (Jin vs ISI)'
      object splISI: TSplitter
        Left = 330
        Top = 0
        Width = 5
        Height = 637
        MinSize = 260
        ResizeStyle = rsUpdate
      end
      object pnlISILeft: TPanel
        Left = 0
        Top = 0
        Width = 330
        Height = 637
        Align = alLeft
        BevelOuter = bvNone
        Padding.Left = 6
        Padding.Top = 6
        Padding.Right = 6
        Padding.Bottom = 6
        TabOrder = 0
        object vleISI: TValueListEditor
          Left = 6
          Top = 6
          Width = 318
          Height = 210
          Align = alTop
          TabOrder = 0
        end
        object pnlISIButtons: TPanel
          Left = 6
          Top = 216
          Width = 318
          Height = 40
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object btnRunISI: TPanel
            Left = 0
            Top = 6
            Width = 112
            Height = 28
            Cursor = crHandPoint
            Hint = 'Steady inter-pulse interval for each constant Jin level (F5)'
            BevelOuter = bvNone
            Caption = 'Run sweep'
            Color = 11694592
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            OnClick = btnRunISIClick
          end
          object btnExportISI: TPanel
            Left = 118
            Top = 6
            Width = 84
            Height = 28
            Cursor = crHandPoint
            Hint = 'Save Jin, spike count, ISI and frequency'
            BevelOuter = bvNone
            Caption = 'Export CSV'
            Color = 15263976
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
            OnClick = btnExportISIClick
          end
          object btnClearISI: TPanel
            Left = 208
            Top = 6
            Width = 52
            Height = 28
            Cursor = crHandPoint
            Hint = 'Clear the charts and results of this tab (parameters are kept)'
            BevelOuter = bvNone
            Caption = 'Clear'
            Color = 15263976
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
            OnClick = btnClearISIClick
          end
          object btnTheoryISI: TPanel
            Left = 266
            Top = 6
            Width = 52
            Height = 28
            Cursor = crHandPoint
            Hint = 'Open sheet 6: inter-pulse interval and spike definitions (F1)'
            BevelOuter = bvNone
            Caption = 'Theory'
            Color = 7043328
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 3
            OnClick = btnSheetClick
          end
        end
        object memISI: TMemo
          Left = 6
          Top = 256
          Width = 318
          Height = 200
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 2
          WordWrap = False
        end
      end
      object gpISI: TGridPanel
        Left = 335
        Top = 0
        Width = 929
        Height = 637
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 100.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = chtISI
            Row = 0
          end
          item
            Column = 0
            Control = chtISITraces
            Row = 1
          end>
        RowCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        TabOrder = 1
        object chtISI: TChart
          Left = 0
          Top = 0
          Width = 929
          Height = 318
          Title.Text.Strings = (
            'TChart')
          Align = alClient
          TabOrder = 0
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
        end
        object chtISITraces: TChart
          Left = 0
          Top = 318
          Width = 929
          Height = 319
          Title.Text.Strings = (
            'TChart')
          Align = alClient
          TabOrder = 1
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
        end
      end
    end
    object tsAPP: TTabSheet
      Caption = '5. APP (Cable Propagation)'
      object splAPP: TSplitter
        Left = 330
        Top = 0
        Width = 5
        Height = 637
        MinSize = 260
        ResizeStyle = rsUpdate
      end
      object pnlAPPLeft: TPanel
        Left = 0
        Top = 0
        Width = 330
        Height = 637
        Align = alLeft
        BevelOuter = bvNone
        Padding.Left = 6
        Padding.Top = 6
        Padding.Right = 6
        Padding.Bottom = 6
        TabOrder = 0
        object rgCableMode: TRadioGroup
          Left = 6
          Top = 6
          Width = 318
          Height = 44
          Align = alTop
          Caption = ' Cable membrane model '
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            'Active (HH membrane)'
            'Passive (RC line, gm)')
          TabOrder = 0
        end
        object rgAPPDrive: TRadioGroup
          Left = 6
          Top = 50
          Width = 318
          Height = 44
          Align = alTop
          Caption = ' Excitation at x = 0 '
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            'Current pulses'
            'APG waveform (tab 1)')
          TabOrder = 1
        end
        object rgAPPScheme: TRadioGroup
          Left = 6
          Top = 94
          Width = 318
          Height = 44
          Align = alTop
          Caption = ' Integration of the cable PDE '
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            'Explicit (FTCS)'
            'Crank-Nicolson')
          TabOrder = 2
        end
        object pnlAPPPresets: TPanel
          Left = 6
          Top = 138
          Width = 318
          Height = 40
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 3
          object btnPresetSquid: TPanel
            Left = 0
            Top = 6
            Width = 156
            Height = 28
            Cursor = crHandPoint
            Hint = 
              'Active cable, one current pulse, a = 238 um, 60 mm, h = 1 mm (HH' +
              ' 1952 velocity)'
            BevelOuter = bvNone
            Caption = 'Squid axon (HH 1952)'
            Color = 15263976
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            OnClick = btnPresetSquidClick
          end
          object btnPresetLecturer: TPanel
            Left = 162
            Top = 6
            Width = 156
            Height = 28
            Cursor = crHandPoint
            Hint = 
              'Passive cable driven by the APG waveform, 2 mm, dx = 0.4 mm, dt ' +
              '= 10 us, 60 ms'
            BevelOuter = bvNone
            Caption = 'Lecturer scale (2 mm)'
            Color = 15263976
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
            OnClick = btnPresetLecturerClick
          end
        end
        object vleAPP: TValueListEditor
          Left = 6
          Top = 178
          Width = 318
          Height = 228
          Align = alTop
          TabOrder = 4
        end
        object pnlAPPButtons: TPanel
          Left = 6
          Top = 406
          Width = 318
          Height = 40
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 5
          object btnRunAPP: TPanel
            Left = 0
            Top = 6
            Width = 140
            Height = 28
            Cursor = crHandPoint
            Hint = 'Solve the cable equation (F5)'
            BevelOuter = bvNone
            Caption = 'Run APP simulation'
            Color = 11694592
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            OnClick = btnRunAPPClick
          end
          object btnExportAPP: TPanel
            Left = 146
            Top = 6
            Width = 100
            Height = 28
            Cursor = crHandPoint
            Hint = 'Save Vm(t) of every node'
            BevelOuter = bvNone
            Caption = 'Export CSV'
            Color = 15263976
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
            OnClick = btnExportAPPClick
          end
          object btnClearAPP: TPanel
            Left = 252
            Top = 6
            Width = 66
            Height = 28
            Cursor = crHandPoint
            Hint = 'Clear the charts and results of this tab (parameters are kept)'
            BevelOuter = bvNone
            Caption = 'Clear'
            Color = 15263976
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
            OnClick = btnClearAPPClick
          end
        end
        object pnlAPPSheets: TPanel
          Left = 6
          Top = 446
          Width = 318
          Height = 40
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 6
          object btnSheetCable: TPanel
            Left = 0
            Top = 6
            Width = 120
            Height = 28
            Cursor = crHandPoint
            Hint = 'Open sheet 4: derivation of the cable equation'
            BevelOuter = bvNone
            Caption = 'Cable equation'
            Color = 7043328
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            OnClick = btnSheetClick
          end
          object btnSheetFD: TPanel
            Left = 126
            Top = 6
            Width = 192
            Height = 28
            Cursor = crHandPoint
            Hint = 'Open sheet 5: central and forward difference scheme (F1)'
            BevelOuter = bvNone
            Caption = 'FD derivation (Problem 2)'
            Color = 7043328
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
            OnClick = btnSheetClick
          end
        end
        object memAPP: TMemo
          Left = 6
          Top = 486
          Width = 318
          Height = 200
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 7
          WordWrap = False
        end
      end
      object pnlAPPRight: TPanel
        Left = 335
        Top = 0
        Width = 929
        Height = 637
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object pnlAPPTimeBar: TPanel
          Left = 0
          Top = 0
          Width = 929
          Height = 40
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            937
            40)
          object lblAPPTime: TLabel
            Left = 838
            Top = 12
            Width = 58
            Height = 15
            Anchors = [akTop, akRight]
            Caption = 't = 0.00 ms'
            ExplicitLeft = 822
          end
          object btnPlay: TPanel
            Left = 6
            Top = 6
            Width = 80
            Height = 28
            Cursor = crHandPoint
            Hint = 'Animate the propagation over time (Esc stops)'
            BevelOuter = bvNone
            Caption = 'Play'
            Color = 3308846
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            OnClick = btnPlayClick
          end
          object tbAPPTime: TTrackBar
            Left = 92
            Top = 6
            Width = 736
            Height = 30
            Hint = 'Time slider: profile, cursor and 3D slice follow it'
            Anchors = [akLeft, akTop, akRight]
            Max = 100
            Frequency = 10
            TabOrder = 1
            TickStyle = tsNone
            OnChange = tbAPPTimeChange
            ExplicitWidth = 720
          end
        end
        object gpAPP: TGridPanel
          Left = 0
          Top = 40
          Width = 937
          Height = 593
          Align = alClient
          BevelOuter = bvNone
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
              Control = chtAPPTime
              Row = 0
            end
            item
              Column = 1
              Control = chtAPPSpace
              Row = 0
            end
            item
              Column = 0
              ColumnSpan = 2
              Control = pnlAPPView
              Row = 1
            end>
          RowCollection = <
            item
              Value = 55.000000000000000000
            end
            item
              Value = 45.000000000000000000
            end>
          TabOrder = 1
          ExplicitWidth = 929
          ExplicitHeight = 597
          object chtAPPTime: TChart
            Left = 0
            Top = 0
            Width = 464
            Height = 328
            Title.Text.Strings = (
              'TChart')
            Align = alClient
            TabOrder = 0
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
          end
          object chtAPPSpace: TChart
            Left = 464
            Top = 0
            Width = 465
            Height = 328
            Title.Text.Strings = (
              'TChart')
            Align = alClient
            TabOrder = 1
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
          end
          object pnlAPPView: TPanel
            Left = 0
            Top = 328
            Width = 929
            Height = 269
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            ParentBackground = False
            TabOrder = 2
            object pbSpaceTime: TPaintBox
              Left = 0
              Top = 40
              Width = 929
              Height = 229
              Align = alClient
              OnPaint = pbSpaceTimePaint
            end
            object pnlAPPViewTools: TPanel
              Left = 0
              Top = 0
              Width = 929
              Height = 40
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
              object lblYaw: TLabel
                Left = 318
                Top = 14
                Width = 36
                Height = 15
                Caption = 'Yaw 35'
              end
              object lblPitch: TLabel
                Left = 540
                Top = 14
                Width = 42
                Height = 15
                Caption = 'Pitch 30'
              end
              object rgAPPView: TRadioGroup
                Left = 6
                Top = 4
                Width = 300
                Height = 38
                Caption = ' View '
                Columns = 3
                ItemIndex = 0
                Items.Strings = (
                  'Heat map'
                  '3D waterfall'
                  '3D mesh')
                TabOrder = 0
                OnClick = rgAPPViewClick
              end
              object tbYaw: TTrackBar
                Left = 368
                Top = 8
                Width = 160
                Height = 28
                Hint = 'Rotate the 3D view about the Vm axis'
                Max = 90
                Min = -90
                Frequency = 15
                Position = 35
                TabOrder = 1
                TickStyle = tsNone
                OnChange = tbViewChange
              end
              object tbPitch: TTrackBar
                Left = 594
                Top = 8
                Width = 160
                Height = 28
                Hint = 'Tilt the 3D view (elevation of the viewer)'
                Max = 80
                Frequency = 10
                Position = 30
                TabOrder = 2
                TickStyle = tsNone
                OnChange = tbViewChange
              end
            end
          end
        end
      end
    end
    object tsModel: TTabSheet
      Caption = '6. Model and Equations'
      object pnlModelLeft: TPanel
        Left = 0
        Top = 0
        Width = 400
        Height = 637
        Align = alLeft
        BevelOuter = bvNone
        Padding.Left = 6
        Padding.Top = 6
        Padding.Right = 6
        Padding.Bottom = 6
        TabOrder = 0
        object vleModel: TValueListEditor
          Left = 6
          Top = 6
          Width = 388
          Height = 190
          Align = alTop
          TabOrder = 0
        end
        object pnlModelButtons: TPanel
          Left = 6
          Top = 196
          Width = 388
          Height = 40
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object btnResetModel: TPanel
            Left = 0
            Top = 6
            Width = 200
            Height = 28
            Cursor = crHandPoint
            Hint = 'Restore gNa0, gK0, gL0, VNa, VK, VL, Cm and temperature'
            BevelOuter = bvNone
            Caption = 'Reset to HH (1952) values'
            Color = 15263976
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            OnClick = btnResetModelClick
          end
        end
        object pnlSheets: TPanel
          Left = 6
          Top = 236
          Width = 388
          Height = 395
          Align = alClient
          BevelOuter = bvNone
          Padding.Top = 8
          TabOrder = 2
          object lblSheets: TLabel
            Left = 0
            Top = 8
            Width = 291
            Height = 15
            Align = alTop
            Caption = 'Mathematical sheets (each opens in its own window)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblSheetsNote: TLabel
            Left = 0
            Top = 260
            Width = 388
            Height = 60
            Align = alTop
            AutoSize = False
            Caption = 
              'Sheet 5 is the Problem 2 derivation. Yellow boxes mark the equat' +
              'ions implemented in the program. F1 opens the sheet of the activ' +
              'e tab.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGrayText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            WordWrap = True
          end
          object btnSheet1: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 26
            Width = 388
            Height = 32
            Cursor = crHandPoint
            Hint = 
              'Open in a separate window: Hodgkin-Huxley equivalent circuit and' +
              ' membrane equations'
            Margins.Left = 0
            Margins.Right = 0
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Sheet 1 - Equivalent circuit and membrane equations'
            Color = 7043328
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            OnClick = btnSheetClick
          end
          object btnSheet2: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 64
            Width = 388
            Height = 32
            Cursor = crHandPoint
            Hint = 'Open in a separate window: Gating kinetics and rate constants'
            Margins.Left = 0
            Margins.Right = 0
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Sheet 2 - Gating kinetics and rate constants'
            Color = 7043328
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
            OnClick = btnSheetClick
          end
          object btnSheet3: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 102
            Width = 388
            Height = 32
            Cursor = crHandPoint
            Hint = 
              'Open in a separate window: Fourth-order Runge-Kutta integration ' +
              'of the HH equations'
            Margins.Left = 0
            Margins.Right = 0
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Sheet 3 - RK4 integration (APG, Problem 1)'
            Color = 7043328
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
            OnClick = btnSheetClick
          end
          object btnSheet4: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 140
            Width = 388
            Height = 32
            Cursor = crHandPoint
            Hint = 
              'Open in a separate window: Cable equation derivation for action ' +
              'potential propagation'
            Margins.Left = 0
            Margins.Right = 0
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Sheet 4 - Cable equation derivation (APP)'
            Color = 7043328
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 3
            OnClick = btnSheetClick
          end
          object btnSheet5: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 178
            Width = 388
            Height = 32
            Cursor = crHandPoint
            Hint = 
              'Open in a separate window: Central and forward difference integr' +
              'ation of the cable PDE'
            Margins.Left = 0
            Margins.Right = 0
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Sheet 5 - Central/forward difference (Problem 2)'
            Color = 7043328
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 4
            OnClick = btnSheetClick
          end
          object btnSheet6: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 216
            Width = 388
            Height = 32
            Cursor = crHandPoint
            Hint = 
              'Open in a separate window: Analysis definitions: spike, ISI, ref' +
              'ractory threshold, velocity'
            Margins.Left = 0
            Margins.Right = 0
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Sheet 6 - Spike, ISI, refractory and velocity'
            Color = 7043328
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 5
            OnClick = btnSheetClick
          end
        end
      end
      object memModelInfo: TMemo
        Left = 400
        Top = 0
        Width = 872
        Height = 637
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
        WordWrap = False
      end
      object sbEquations: TScrollBox
        Left = 400
        Top = 0
        Width = 872
        Height = 637
        Align = alClient
        BorderStyle = bsNone
        Color = clWhite
        ParentColor = False
        TabOrder = 2
        object imgEquations: TImage
          Left = 12
          Top = 12
          Width = 400
          Height = 300
        end
        object imgNomenclature: TImage
          Left = 12
          Top = 336
          Width = 400
          Height = 300
        end
      end
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CSV files (*.csv)|*.csv|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 1144
    Top = 8
  end
  object SaveDialogPNG: TSaveDialog
    DefaultExt = 'png'
    Filter = 'PNG images (*.png)|*.png'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 1176
    Top = 8
  end
  object tmrPlay: TTimer
    Enabled = False
    Interval = 40
    OnTimer = tmrPlayTimer
    Left = 1208
    Top = 8
  end
  object tmrRefDebounce: TTimer
    Enabled = False
    Interval = 250
    OnTimer = tmrRefDebounceTimer
    Left = 1240
    Top = 8
  end
end
