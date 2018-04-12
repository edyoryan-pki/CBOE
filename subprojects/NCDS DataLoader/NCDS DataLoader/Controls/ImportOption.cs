using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using CambridgeSoft.COE.DataLoader.Core;
using System.Diagnostics;
using System.IO;
using System.Threading;
using CambridgeSoft.COE.DataLoader.Common;
using System.Text.RegularExpressions;
using System.Data.OleDb;

namespace CambridgeSoft.NCDS_DataLoader.Controls
{
    public partial class ImportOption : UIBase
    {
        private JobParameters _job;
        private string _dataUploaderPath;
        private string _xmlPath;
        private string _userName;
        private string _password;
        private string _ImportOption;
        private string _FullFilePath;
        private string _strFilePath;
        private bool _backToFront = false;
        private bool _skipflag = false;
        private string _CommandPath;
        private string[] _splitFiles;
        private Process[] p;
        private Mutex mut = new Mutex();
        public JobParameters JOB
        {
            set { this._job = value; }
        }
        public string[] SplitFiles
        {
            set { _splitFiles = value; }
        }
        public string UserName
        {
            set { this._userName = value; }
        }
        public string Password
        {
            set { this._password = value; }
        }
        public string FullFilePath
        {
            set { this._FullFilePath = value; }
        }
        public string StrFilePath
        {
            set { this._strFilePath = value; }
        }
        public string XmlPath
        {
            set { this._xmlPath = value; }
        }

        public bool OptionPanelEnabled
        {
            set { this._OptionPanel.Enabled = value; }
        }

        public bool ResultVisable
        {
            set
            {
                _ResultLabel.Visible = value;
                _ResultRichTextBox.Visible = false;
            }
        }

        public bool BackToFront
        {
            get { return _backToFront; }
        }

        public bool Skipflag
        {
            set { _skipflag = value; }
        }

        public string CommandPath
        {
            get { return _CommandPath; }
        }


        public ImportOption()
        {
            InitializeComponent();
            Controls.Add(AcceptButton);
            Controls.Add(CancelButton);
            AcceptButton.Click += new EventHandler(AcceptButton_Click);
            CancelButton.Click += new EventHandler(CancelButton_Click);
            _ResultLabel.Visible = false;
            _ResultRichTextBox.Visible = false;
            //Control.CheckForIllegalCrossThreadCalls = false;


        }

        private void AcceptButton_Click(object sender, EventArgs e)
        {
            try
            {

                base.Cursor = Cursors.WaitCursor;
                if (AcceptButton.Text == "Exit")
                {
                    OnAccept();
                }
                _dataUploaderPath = string.Empty;

                    string strFolder = System.AppDomain.CurrentDomain.BaseDirectory;
                    _dataUploaderPath = strFolder + "DataLoader2\\COEDataLoader.exe";

                if (!System.IO.File.Exists(_dataUploaderPath))
                {
                    MessageBox.Show("Can't find COEDataLoader.exe. Please confim the path.", "NCDS DataLoader", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                string strFile = _FullFilePath;
                if (!System.IO.File.Exists(strFile))
                {
                    MessageBox.Show("Input file error.", "NCDS DataLoader", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                if (!System.IO.File.Exists(_xmlPath))
                {
                    MessageBox.Show("Mapping file error.", "NCDS DataLoader", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                this._OptionPanel.Enabled = false;

                if (_ImportTempRadioButton.Checked == true)
                {
                    _ImportOption = "ImportTemp";
                }
                else if (_ImportRegDupNoneRadioButton.Checked == true)
                {
                    _ImportOption = "ImportRegDupNone";
                }
                else if (_ImportRegDupAsTempRadioButton.Checked == true)
                {
                    _ImportOption = "ImportRegDupAsTemp";
                }
                else if (_ImportRegDupAsCreateNewRadioButton.Checked == true)
                {
                    _ImportOption = "ImportRegDupAsCreateNew";
                }
                else if (_ImportRegDupAsCreateNewBatchRadioButton.Checked == true)
                {
                    _ImportOption = "ImportRegDupAsNewBatch";
                }
                _ResultLabel.Visible = false;
                _ResultRichTextBox.Visible = false;
                if (AcceptButton.Text=="Next")
                {
                    if (_splitFiles != null)
                    {
                        p = new Process[_splitFiles.Length - 3];

                        for (int i = 2; i < _splitFiles.Length - 1; i++)
                        {
                            int j = 0;
                            _FullFilePath = _splitFiles[i];
                            ExecuteCOEDataLoader(j);
                            Thread.Sleep(10000);
                            j++;
                        }

                        t.SynchronizingObject = this;
                        t.Elapsed += new System.Timers.ElapsedEventHandler(timerProcess);
                        t.AutoReset = true;
                        t.Enabled = true;

                                            }
                    else
                    {
                        ExecuteCOEDataLoader();
                    }
               }
               
            }
            catch (Exception ex)
            {
                string message = ex.Message + "\n" + ex.StackTrace;
                Trace.WriteLine(DateTime.Now, "Time ");
                Trace.WriteLine(message, "ImportOption");
                Trace.Flush();
                MessageBox.Show(ex.Message, "NCDS DataLoader", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            finally
            {
                base.Cursor = Cursors.Default;
            }

            AcceptButton.Text = "Exit";

            //OnAccept(); // The parent will check to make certain the file exists
        }
        System.Timers.Timer t = new System.Timers.Timer(10000);

        public void timerProcess(object source,System.Timers.ElapsedEventArgs e)
        {
            string name = "COEDataLoader";
            Process[] prc = Process.GetProcesses();
            foreach (Process pr in prc)
            {
                if (name == pr.ProcessName)
                {
                    return;
                }
            }
            t.Enabled = false;

            string[] logFullPath = FindLastFileSplit(_splitFiles.Length - 3);
            if (logFullPath.Length == _splitFiles.Length - 3)
            {
                string[] arraystring = new string[logFullPath.Length];
                for (int i = 0; i < logFullPath.Length; i++) 
                {
                    StringBuilder result = new StringBuilder();
                    StreamReader textStr = new StreamReader(logFullPath[i]);
                    string strLine = string.Empty;
                    bool startRead = false;
                    int lineCount = 0;
                    while (!textStr.EndOfStream)
                    {
                        strLine = textStr.ReadLine();
                        if (startRead)
                        {
                            result.Append(strLine + "\n");
                            lineCount++;
                        }
                        if (CambridgeSoft.NCDS_DataLoader.Properties.Resources.Log_Seperator.Equals(strLine))
                        {
                            startRead = true;
                        }
                    }
                    textStr.Close();
                    string strResult = string.Empty;
                    if (result.ToString().StartsWith(((char)34).ToString()) &&
                        result.ToString().Trim().EndsWith(((char)34).ToString()))
                    {
                        strResult = result.ToString().Trim().Substring(1, result.ToString().Trim().Length - 2);
                    }
                    arraystring[i] = strResult;
                }
                         int one = 0;
                         int two = 0;
                         int three = 0;
                         int four = 0;
                         int five = 0;
                for (int i = 0; i < arraystring.Length; i++)
                {
                    string st = arraystring[i];
                    string resul = st.Replace('\n', ' ');
                    Regex rx = new Regex(@"You chose to load records from 1 to (\d+) \((\d+) records in total\).* (\d+) records are successfully registered, in which (\d+) are temporary, (\d+) are permanent.",
                    RegexOptions.Compiled | RegexOptions.IgnoreCase);

                   
                    Match m = rx.Match(resul);
                    while (m.Success)
                    {
                        one += System.Convert.ToInt32(m.Groups[1].ToString());
                        two += System.Convert.ToInt32(m.Groups[2].ToString());
                        three += System.Convert.ToInt32(m.Groups[3].ToString());
                        four += System.Convert.ToInt32(m.Groups[4].ToString());
                        five += System.Convert.ToInt32(m.Groups[5].ToString());
                        m = m.NextMatch();
                    }
                    Regex rx2 = new Regex(@"You chose to load records from 1 to (\d+) \((\d+) records in total\).* No action taken",
                   RegexOptions.Compiled | RegexOptions.IgnoreCase);

                    Match m2 = rx2.Match(resul);
                    while (m2.Success)
                    {
                        one += System.Convert.ToInt32(m2.Groups[1].ToString());
                        two += System.Convert.ToInt32(m2.Groups[2].ToString());
                        m2 = m2.NextMatch();
                    }
                }
                _ResultLabel.Visible = true;
                _ResultRichTextBox.Visible = false;
                _ResultLabel.Text = "You chose to load records from 1 to " + one + " (" + two + " records in total) \n " + three + " records are successfully registered, in which " + four + " are temporary, " + five + " are permanent.";

                }
        }

        private void CancelButton_Click(object sender, EventArgs e)
        {
            OnCancel();
        }

        private void _ImportAnotherFile_Click(object sender, EventArgs e)
        {
            _backToFront = true;
            OnAccept();
        }

        private void ExecuteCOEDataLoader(int j)
        {
            if (_skipflag)
            {
                string strFile = _strFilePath;
                bool boolflag = _job.DataSourceInformation.HasHeaderRow;

                if (strFile.ToLower().EndsWith(".txt"))
                {
                    if (boolflag)
                    {
                        string[] strText = System.IO.File.ReadAllLines(strFile);
                        string headerText = strText[0].ToString();

                        //string strFileSplit = splitFilePath;
                        string[] strTextSplit = System.IO.File.ReadAllLines(_FullFilePath);
                        //string headerText = strText[0].ToString();
                        if (strTextSplit[0].ToString() != strText[0].ToString())
                        {
                            string cont = System.IO.File.ReadAllText(_FullFilePath);
                            string headerTexts = headerText + "\r" + cont;
                            System.IO.File.Delete(_FullFilePath);       

                            FileStream fsas = new FileStream(_FullFilePath, FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.ReadWrite);
                            StreamWriter swa = new StreamWriter(fsas);

                            swa.WriteLine(headerTexts);
                            swa.Close();
                            fsas.Close();
                        }
                    }
                }

                if (strFile.ToLower().EndsWith(".xls") ||
                    strFile.ToLower().EndsWith(".xlsx"))
                {
                    if (boolflag)
                    {
                        string strHead = "NO";
                        if (_job.DataSourceInformation.HasHeaderRow)
                        { strHead = "NO"; }
                        else
                        {
                            strHead = "YES";
                        }
                        string strCon = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strFile + ";Extended Properties=\"Excel 8.0;HDR=" + strHead + ";IMEX=1\"";
                        OleDbConnection myConn = new OleDbConnection(strCon);
                        string sheetname = _job.DataSourceInformation.TableName;
                        //string strCom = " SELECT * FROM [Sheet1]";
                        string strCom = " SELECT * FROM [" + sheetname + "$]";
                        myConn.Open();
                        //DataTable sheetNames = myConn.GetOleDbSchemaTable
                        //(System.Data.OleDb.OleDbSchemaGuid.Tables, new object[] { null, null, null, "TABLE" });
                        //DataRow dr = sheetNames.Rows[0];

                        OleDbDataAdapter myCommand = new OleDbDataAdapter(strCom, myConn);
                        DataSet ds = new DataSet();
                        myCommand.Fill(ds);
                        myConn.Close();
                        string headerText = "";

                        for (int k = 0; k < ds.Tables[0].Columns.Count; k++)
                        {
                            headerText += ds.Tables[0].Rows[0][k].ToString() + "\t";
                        }



                        string[] strTextSplit = System.IO.File.ReadAllLines(_FullFilePath);

                        if (strTextSplit[0].ToString() != headerText)
                        {
                            headerText = headerText.Trim();
                            string cont = System.IO.File.ReadAllText(_FullFilePath);
                            string headerTexts = headerText + "\r" + cont;
                            System.IO.File.Delete(_FullFilePath);


                            FileStream fsas = new FileStream(_FullFilePath, FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.ReadWrite);
                            StreamWriter swa = new StreamWriter(fsas);

                            swa.WriteLine(headerTexts);
                            swa.Close();
                            fsas.Close();
                        }
                    }
                }
            }

            ProcessStartInfo start = new ProcessStartInfo(_dataUploaderPath);

            string strArg = "/act:" + _ImportOption + "\n\r" +
                              "/data:" + _FullFilePath + "\n\r" +
                //" /type:" + _job.DataSourceInformation.FileType +
                              "/mapping:" + _xmlPath + "\n\r" +
                              "/begin:1" + "\n\r" +
                              "/end:2147483647" + "\n\r";

            if (_FullFilePath.ToLower().EndsWith(".xls") ||
                _FullFilePath.ToLower().EndsWith(".xlsx"))
            {
                strArg = strArg + "/tbl:" + _job.DataSourceInformation.TableName + "\n\r" +
                         "/header:" + ((_job.DataSourceInformation.HasHeaderRow) ? "+" : "-") + "\n\r" +
                         "/type:" + "MSExcel";
            }
            else if (_FullFilePath.ToLower().EndsWith(".txt"))
            {
                strArg = strArg + "/header:" + ((_job.DataSourceInformation.HasHeaderRow) ? "+" : "-");
                if (_job.DataSourceInformation.FileType == SourceFileType.MSExcel)
                {
                    strArg = strArg + "\n\r" + "/delimiter:\\t" + "\n\r" +
                    "/type:" + "CSV";
                }
                else
                {
                    strArg += "\n\r" + "/delimiter:" + (_job.DataSourceInformation.FieldDelimiters[0].ToString().Equals("\t") ? "\\t" :
                    _job.DataSourceInformation.FieldDelimiters[0].ToString()) + "\n\r" +
                    "/type:" + "CSV";
                }
            }
            else
            {
                strArg = strArg + "/type:" + _job.DataSourceInformation.FileType;
            }

            // Export Command File
            _CommandPath = "C:\\" + Path.GetFileName(_FullFilePath) + ".Command" + ".txt";
            int index = 1;

            while (File.Exists(_CommandPath))
            {
                _CommandPath = "C:\\" + Path.GetFileName(_FullFilePath) + ".Command" + index.ToString() + ".txt";
                index++;
            }
            FileStream fs = new FileStream(_CommandPath, FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.ReadWrite);
            StreamWriter sw = new StreamWriter(fs);
            sw.WriteLine(strArg);
            sw.Close();
            fs.Close();

            start.Arguments = " /command:" + _CommandPath + " /username:" + _userName +
                              " /password:" + _password;

            start.CreateNoWindow = false;
            //**************************************************************************
            
            //start.RedirectStandardOutput = true;//
            //start.RedirectStandardInput = true;//
            //**************************************************************************
            start.UseShellExecute = false;


            string logFullPathBefore = FindLastFile();

           using( p[j] = new Process()){
            p[j].StartInfo = start;
            p[j].Start();

            //**************************************************************************
            //StringBuilder strResult1 = new StringBuilder();
            //StreamReader reader = p.StandardOutput;
            //string line = reader.ReadLine();
            //while (!reader.EndOfStream)
            //{
            //    strResult1.Append(line + "\n");
            //    line = reader.ReadLine();
            //}
            //**************************************************************************
            //p.WaitForExit();
            p[j].Close();}
           
        }

        private void ExecuteCOEDataLoader()
        {

            ProcessStartInfo start = new ProcessStartInfo(_dataUploaderPath);

            string strArg = "/act:" + _ImportOption + "\n\r" +
                              "/data:" + _FullFilePath + "\n\r" +
                //" /type:" + _job.DataSourceInformation.FileType +
                              "/mapping:" + _xmlPath + "\n\r" +
                              "/begin:1" + "\n\r" +
                              "/end:2147483647" + "\n\r";

            if (_FullFilePath.ToLower().EndsWith(".xls") ||
                _FullFilePath.ToLower().EndsWith(".xlsx"))
            {
                strArg = strArg + "/tbl:" + _job.DataSourceInformation.TableName + "\n\r" +
                         "/header:" + ((_job.DataSourceInformation.HasHeaderRow) ? "+" : "-") + "\n\r" +
                         "/type:" + "MSExcel";
            }
            else if (_FullFilePath.ToLower().EndsWith(".txt"))
            {
                strArg = strArg + "/header:" + ((_job.DataSourceInformation.HasHeaderRow) ? "+" : "-");
                if (_job.DataSourceInformation.FileType == SourceFileType.MSExcel)
                {
                    strArg = strArg + "\n\r" + "/delimiter:\\t" + "\n\r" +
                    "/type:" + "CSV";
                }
                else
                {
                    strArg += "\n\r" + "/delimiter:" + (_job.DataSourceInformation.FieldDelimiters[0].ToString().Equals("\t") ? "\\t" :
                    _job.DataSourceInformation.FieldDelimiters[0].ToString()) + "\n\r" +
                    "/type:" + "CSV";
                }
            }
            else
            {
                strArg = strArg + "/type:" + _job.DataSourceInformation.FileType;
            }

            // Export Command File
            _CommandPath = "C:\\" + Path.GetFileName(_FullFilePath) + ".Command" + ".txt";
            int index = 1;

            while (File.Exists(_CommandPath))
            {
                _CommandPath = "C:\\" + Path.GetFileName(_FullFilePath) + ".Command" + index.ToString() + ".txt";
                index++;
            }
            FileStream fs = new FileStream(_CommandPath, FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.ReadWrite);
            StreamWriter sw = new StreamWriter(fs);
            sw.WriteLine(strArg);
            sw.Close();
            fs.Close();
            start.Arguments = " /command:" + _CommandPath + " /username:" + _userName +
                              " /password:" + _password;

            start.CreateNoWindow = false;
            //**************************************************************************

            //start.RedirectStandardOutput = true;//
            //start.RedirectStandardInput = true;//
            //**************************************************************************
            start.UseShellExecute = false;


            string logFullPathBefore = FindLastFile();

            Process p = new Process();
            p.StartInfo = start;
            p.Start();

            //**************************************************************************
            //StringBuilder strResult1 = new StringBuilder();
            //StreamReader reader = p.StandardOutput;
            //string line = reader.ReadLine();
            //while (!reader.EndOfStream)
            //{
            //    strResult1.Append(line + "\n");
            //    line = reader.ReadLine();
            //}
            //**************************************************************************
            p.WaitForExit();
            p.Close();


            string logFullPath = FindLastFile();
            if (File.Exists(logFullPath) && logFullPathBefore != logFullPath)
            {
                StringBuilder result = new StringBuilder();
                StreamReader textStr = new StreamReader(logFullPath);
                string strLine = string.Empty;
                bool startRead = false;
                int lineCount = 0;
                while (!textStr.EndOfStream)
                {
                    strLine = textStr.ReadLine();
                    if (startRead)
                    {
                        result.Append(strLine + "\n");
                        lineCount++;
                    }
                    if (CambridgeSoft.NCDS_DataLoader.Properties.Resources.Log_Seperator.Equals(strLine))
                    {
                        startRead = true;
                    }
                }
                textStr.Close();
                string strResult = string.Empty;
                if (result.ToString().StartsWith(((char)34).ToString()) &&
                    result.ToString().Trim().EndsWith(((char)34).ToString()))
                {
                    strResult = result.ToString().Trim().Substring(1, result.ToString().Trim().Length - 2);
                }
                if (lineCount <= 3)
                {
                    _ResultLabel.Visible = true;
                    _ResultRichTextBox.Visible = false;
                    _ResultLabel.Text = (string.IsNullOrEmpty(strResult) ? "Import failed." : strResult);
                }
                else
                {
                    _ResultLabel.Visible = false;
                    _ResultRichTextBox.Visible = true;
                    _ResultRichTextBox.Text = (string.IsNullOrEmpty(strResult) ? "Import failed." : strResult);
                }
            }
            else
            {
                _ResultLabel.Visible = true;
                _ResultRichTextBox.Visible = false;
                _ResultLabel.Text = "Import failed.";
            }
        }

        public string FindLastFile()
        {
            string logFullPath = CambridgeSoft.COE.DataLoader.Core.Workflow.JobUtility.GetLogFilePath();
            int index = logFullPath.LastIndexOf("\\");
            string logPath = Path.GetDirectoryName(logFullPath);
            DirectoryInfo d = new DirectoryInfo(logPath);
            FileInfo[] list = d.GetFiles();

            Array.Sort<FileInfo>(list, new FIleLastTimeComparer());

            if (list.Length > 0)
            {
                logFullPath = list[list.Length - 1].FullName;
            }
            else
            {
                logFullPath = string.Empty;
            }
            return logFullPath;
        }

        public string[] FindLastFileSplit(int num)
        {
            string[] splitPath = new string[num];
            string logFullPath = CambridgeSoft.COE.DataLoader.Core.Workflow.JobUtility.GetLogFilePath();
            int index = logFullPath.LastIndexOf("\\");
            string logPath = Path.GetDirectoryName(logFullPath);
            DirectoryInfo d = new DirectoryInfo(logPath);
            FileInfo[] list = d.GetFiles();

            Array.Sort<FileInfo>(list, new FIleLastTimeComparer());

            if (list.Length > 0)
            {
                for (int i = 0; i < num; i++)
                {
                    logFullPath = list[list.Length - 1-i].FullName;
                    splitPath[i] = logFullPath;
                }
            }
            else
            {
                //splitPath = string.Empty;
            }
            return splitPath;
        }


        public void AuthorizeUser()
        {
            //these two permisions dictate access to the temporary Registry
            bool hasRegTempPermission = (
                Csla.ApplicationContext.User.IsInRole("ADD_COMPOUND_TEMP")
                || Csla.ApplicationContext.User.IsInRole("REGISTER_TEMP")
            );

            _ImportTempRadioButton.Enabled = hasRegTempPermission;
            //these two permisions dictate access to the permanent Registry
            bool hasRegPermPermission = (
                Csla.ApplicationContext.User.IsInRole("ADD_COMPONENT")
                || Csla.ApplicationContext.User.IsInRole("EDIT_COMPOUND_REG")
                || Csla.ApplicationContext.User.IsInRole("REGISTER_DIRECT")
            );

            _ImportRegDupNoneRadioButton.Enabled = hasRegPermPermission;
            _ImportRegDupAsTempRadioButton.Enabled = hasRegPermPermission;
            _ImportRegDupAsCreateNewRadioButton.Enabled = hasRegPermPermission;
            _ImportRegDupAsCreateNewBatchRadioButton.Enabled = hasRegPermPermission;

            if(hasRegTempPermission == false && hasRegPermPermission == false)
            {
                AcceptButton.Text = "Exit";
                _ResultLabel.Visible = true;
                _ResultRichTextBox.Visible = false;
                _ResultLabel.Text = "Insufficient privileges for requested operation.";
            }
        }
    }

    public class FIleLastTimeComparer : IComparer<FileInfo>
    {
        #region IComparer<FileInfo> 
        public int Compare(FileInfo x, FileInfo y)
        {
            return x.LastWriteTime.CompareTo(y.LastWriteTime);
        }
        #endregion
    } 
}
