classdef Signal_Analysis < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        GridLayout                    matlab.ui.container.GridLayout
        LeftPanel                     matlab.ui.container.Panel
        STARTButton                   matlab.ui.control.Button
        TIMEDELAYDropDown             matlab.ui.control.DropDown
        TIMEDELAYLabel                matlab.ui.control.Label
        TYPEOFFUNCTIONDropDown        matlab.ui.control.DropDown
        TYPEOFFUNCTIONDropDownLabel   matlab.ui.control.Label
        SIGNALANALYSISbyMATLABLabel   matlab.ui.control.Label
        CenterPanel                   matlab.ui.container.Panel
        GridLayout1                   matlab.ui.container.GridLayout
        UIAxes2                       matlab.ui.control.UIAxes
        UIAxes1                       matlab.ui.control.UIAxes
        RightPanel                    matlab.ui.container.Panel
        GridLayout2                   matlab.ui.container.GridLayout
        ThecalculatedSNRdBEditField   matlab.ui.control.EditField
        ThecalculatedSNRisLabel       matlab.ui.control.Label
        ThedistancetotheobstaclekmEditField  matlab.ui.control.EditField
        ThedistancetotheobstacleisLabel  matlab.ui.control.Label
        CreatedbyMaciejMatusiakLabel  matlab.ui.control.Label
        UIAxes3                       matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
        twoPanelWidth = 768;
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: STARTButton
        function ButtonPushed(app, ~)
            T = app.TIMEDELAYDropDown.Value;
            Nr = app.TYPEOFFUNCTIONDropDown.Value;

            c1=physconst('LightSpeed');
            Fp = 40e6;
            Fs1 = 2e3;
            Fs2 = 2e6;
            Ds = 10e-6;
            t =  0:1/Fp:Ds;

            switch T
                case '1'
                    T=100;
                case '2'
                    T=150;
                case '3'
                    T=200;
                case '4'
                    T=250;
                otherwise
                    disp('The value of time is incorrect, please try again')
                    return
            end

            switch Nr
                case '1'
                    os = sin(2*pi*Fs2*t);
                case '2'
                    os = zeros(1,length(t));  os(1) = 1;  
                case '3'
                    os = chirp(t,Fs1,Ds,Fs2);
                case '4'
                    xt = sin(2*pi*Fs2*t);
                    os = randn(size(xt));
                otherwise
                    disp('The value of the function is incorrect, please try again')
                    return
            end

            r = 0.01*randn(size(os));
            x1=os;              x2 = r+x1;
            y1=[x1,0.01*randn(1,2000,'double')];
            y2=[0.01*randn(1,T,'double'),x2,0.01*randn(1,2000,'double')];
            kmax=2000;
            k1=-kmax:kmax;
            Rxx=xcorr(y2,y1,kmax);
            
            [c,lags] = xcorr(y2,y1);
            [~,maxlag] = max(c);
            t1 = lags(maxlag);  t_nor =  t1*1e-6;
            s = c1 * t_nor/2;   s = s*1e-3;
            str_dis=string(s);
            app.ThedistancetotheobstaclekmEditField.Value=str_dis;
            
            signal = x1;
            noise = r;
            L = snr(signal,noise);
            str_snr=string(L);
            app.ThecalculatedSNRdBEditField.Value=str_snr;
            

            plot(app.UIAxes1,t*1e6,x1,'b')
            title(app.UIAxes1,'SIGNAL SENT')
            xlabel(app.UIAxes1,'Time (μs)','FontSize',10)
            ylabel(app.UIAxes1,'Amplitude','FontSize',10)

            plot(app.UIAxes2,t*1e6,x2,'b')
            title(app.UIAxes2,'SIGNAL RECEIVED')
            xlabel(app.UIAxes2,'Time (μs)','FontSize',10)
            ylabel(app.UIAxes2,'Amplitude','FontSize',10)
            
            plot(app.UIAxes3,k1,Rxx,'b')
            title(app.UIAxes3,'SIGNAL CORRELATION')
            xlabel(app.UIAxes3,'Delay','FontSize',10)
            ylabel(app.UIAxes3,'Correlation','FontSize',10)
            
        end

        % Value changed function: ThedistancetotheobstaclekmEditField
        function ThedistancetotheobstaclekmEditFieldValueChanged(app, ~)
            app.ThedistancetotheobstaclekmEditField.Value;
            
        end
        % Value changed function: ThecalculatedSNRdBEditField
        function ThecalculatedSNRdBEditFieldValueChanged(app, ~)
            app.ThecalculatedSNRdBEditField.Value;
            
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, ~)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 3x1 grid
                app.GridLayout.RowHeight = {468, 468, 468};
                app.GridLayout.ColumnWidth = {'1x'};
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = 1;
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 3;
                app.RightPanel.Layout.Column = 1;
            elseif (currentFigureWidth > app.onePanelWidth && currentFigureWidth <= app.twoPanelWidth)
                % Change to a 2x2 grid
                app.GridLayout.RowHeight = {468, 468};
                app.GridLayout.ColumnWidth = {'1x', '1x'};
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = [1,2];
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 2;
            else
                % Change to a 1x3 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {161, '1x', 368};
                app.LeftPanel.Layout.Row = 1;
                app.LeftPanel.Layout.Column = 1;
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = 2;
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 3;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 880 468];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {161, '1x', 368};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create SIGNALANALYSISbyMATLABLabel
            app.SIGNALANALYSISbyMATLABLabel = uilabel(app.LeftPanel);
            app.SIGNALANALYSISbyMATLABLabel.HorizontalAlignment = 'center';
            app.SIGNALANALYSISbyMATLABLabel.FontSize = 16;
            app.SIGNALANALYSISbyMATLABLabel.FontWeight = 'bold';
            app.SIGNALANALYSISbyMATLABLabel.FontColor = [0.502 0.502 0.502];
            app.SIGNALANALYSISbyMATLABLabel.Position = [7 376 149 72];
            app.SIGNALANALYSISbyMATLABLabel.Text = {'SIGNAL ANALYSIS'; 'by MATLAB'};

            % Create TYPEOFFUNCTIONDropDownLabel
            app.TYPEOFFUNCTIONDropDownLabel = uilabel(app.LeftPanel);
            app.TYPEOFFUNCTIONDropDownLabel.HorizontalAlignment = 'center';
            app.TYPEOFFUNCTIONDropDownLabel.FontWeight = 'bold';
            app.TYPEOFFUNCTIONDropDownLabel.Position = [21 275 122 22];
            app.TYPEOFFUNCTIONDropDownLabel.Text = 'TYPE OF FUNCTION';

            % Create TYPEOFFUNCTIONDropDown
            app.TYPEOFFUNCTIONDropDown = uidropdown(app.LeftPanel);
            app.TYPEOFFUNCTIONDropDown.Items = {'DEFAULT', 'SINUS', 'Dirac delta', 'Chrip', 'White noise'};
            app.TYPEOFFUNCTIONDropDown.ItemsData = {'0', '1', '2', '3', '4'};
            app.TYPEOFFUNCTIONDropDown.FontWeight = 'bold';
            app.TYPEOFFUNCTIONDropDown.BackgroundColor = [0.8 0.8 0.8];
            app.TYPEOFFUNCTIONDropDown.Position = [21 246 122 22];
            app.TYPEOFFUNCTIONDropDown.Value = '0';

            % Create TIMEDELAYLabel
            app.TIMEDELAYLabel = uilabel(app.LeftPanel);
            app.TIMEDELAYLabel.HorizontalAlignment = 'center';
            app.TIMEDELAYLabel.FontWeight = 'bold';
            app.TIMEDELAYLabel.Position = [29 196 115 22];
            app.TIMEDELAYLabel.Text = 'TIME DELAY';

            % Create TIMEDELAYDropDown
            app.TIMEDELAYDropDown = uidropdown(app.LeftPanel);
            app.TIMEDELAYDropDown.Items = {'DEFAULT', '100', '150', '200', '250'};
            app.TIMEDELAYDropDown.ItemsData = {'0', '1', '2', '3', '4'};
            app.TIMEDELAYDropDown.FontWeight = 'bold';
            app.TIMEDELAYDropDown.BackgroundColor = [0.8 0.8 0.8];
            app.TIMEDELAYDropDown.Position = [23 167 121 22];
            app.TIMEDELAYDropDown.Value = '0';

            % Create STARTButton
            app.STARTButton = uibutton(app.LeftPanel, 'push');
            app.STARTButton.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.STARTButton.IconAlignment = 'center';
            app.STARTButton.BackgroundColor = [0.8 0.8 0.8];
            app.STARTButton.FontSize = 18;
            app.STARTButton.FontWeight = 'bold';
            app.STARTButton.Position = [18 45 127 39];
            app.STARTButton.Text = 'START';

            % Create CenterPanel
            app.CenterPanel = uipanel(app.GridLayout);
            app.CenterPanel.Layout.Row = 1;
            app.CenterPanel.Layout.Column = 2;

            % Create GridLayout1
            app.GridLayout1 = uigridlayout(app.CenterPanel);
            app.GridLayout1.ColumnWidth = {'1x'};
            app.GridLayout1.RowHeight = {'1x', '1.06x'};
            app.GridLayout1.Padding = [20 10 20 10];

            % Create UIAxes1
            app.UIAxes1 = uiaxes(app.GridLayout1);
            title(app.UIAxes1, 'Title')
            xlabel(app.UIAxes1, 'X')
            ylabel(app.UIAxes1, 'Y')
            zlabel(app.UIAxes1, 'Z')
            app.UIAxes1.XGrid = 'on';
            app.UIAxes1.YGrid = 'on';
            app.UIAxes1.Layout.Row = 1;
            app.UIAxes1.Layout.Column = 1;

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.GridLayout1);
            title(app.UIAxes2, 'Title')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.XGrid = 'on';
            app.UIAxes2.YGrid = 'on';
            app.UIAxes2.Layout.Row = 2;
            app.UIAxes2.Layout.Column = 1;

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 3;

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.RightPanel);
            app.GridLayout2.ColumnWidth = {127, 44, 49, 123};
            app.GridLayout2.RowHeight = {'6.09x', '2.04x', 22, 22, '1x', 37};
            app.GridLayout2.ColumnSpacing = 1.8;
            app.GridLayout2.Padding = [1.8 10 1.8 10];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.GridLayout2);
            title(app.UIAxes3, 'Title')
            xlabel(app.UIAxes3, 'X')
            ylabel(app.UIAxes3, 'Y')
            zlabel(app.UIAxes3, 'Z')
            app.UIAxes3.XGrid = 'on';
            app.UIAxes3.YGrid = 'on';
            app.UIAxes3.Layout.Row = 1;
            app.UIAxes3.Layout.Column = [1 4];

            % Create CreatedbyMaciejMatusiakLabel
            app.CreatedbyMaciejMatusiakLabel = uilabel(app.GridLayout2);
            app.CreatedbyMaciejMatusiakLabel.HorizontalAlignment = 'right';
            app.CreatedbyMaciejMatusiakLabel.VerticalAlignment = 'bottom';
            app.CreatedbyMaciejMatusiakLabel.FontSize = 11;
            app.CreatedbyMaciejMatusiakLabel.FontWeight = 'bold';
            app.CreatedbyMaciejMatusiakLabel.Layout.Row = 6;
            app.CreatedbyMaciejMatusiakLabel.Layout.Column = [1 4];
            app.CreatedbyMaciejMatusiakLabel.Text = 'Created by Maciej Matusiak  ';

            % Create ThedistancetotheobstacleisLabel
            app.ThedistancetotheobstacleisLabel = uilabel(app.GridLayout2);
            app.ThedistancetotheobstacleisLabel.Layout.Row = 3;
            app.ThedistancetotheobstacleisLabel.Layout.Column = [1 3];
            app.ThedistancetotheobstacleisLabel.Text = '  The distance to the obstacle (km)';

            % Create ThedistancetotheobstaclekmEditField
            app.ThedistancetotheobstaclekmEditField = uieditfield(app.GridLayout2, 'text');
            app.ThedistancetotheobstaclekmEditField.ValueChangedFcn = createCallbackFcn(app, @ThedistancetotheobstaclekmEditFieldValueChanged, true);
            app.ThedistancetotheobstaclekmEditField.Editable = 'off';
            app.ThedistancetotheobstaclekmEditField.Layout.Row = 3;
            app.ThedistancetotheobstaclekmEditField.Layout.Column = 4;

            % Create ThecalculatedSNRisLabel
            app.ThecalculatedSNRisLabel = uilabel(app.GridLayout2);
            app.ThecalculatedSNRisLabel.Layout.Row = 4;
            app.ThecalculatedSNRisLabel.Layout.Column = [1 2];
            app.ThecalculatedSNRisLabel.Text = '  The calculated SNR (dB)';

            % Create ThecalculatedSNRdBEditField
            app.ThecalculatedSNRdBEditField = uieditfield(app.GridLayout2, 'text');
            app.ThecalculatedSNRdBEditField.ValueChangedFcn = createCallbackFcn(app, @ThecalculatedSNRdBEditFieldValueChanged, true);
            app.ThecalculatedSNRdBEditField.Editable = 'off';
            app.ThecalculatedSNRdBEditField.Layout.Row = 4;
            app.ThecalculatedSNRdBEditField.Layout.Column = 4;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Signal_Analysis

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end