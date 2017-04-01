using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Gravity
{
    public partial class Service1 : ServiceBase
    {
        static string commonFolder = Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData).Replace("\\", "/");
        static string gravityDir = String.Format("{0}/gravity", commonFolder);
        static string gravityConfig = String.Format("{0}/gravity/config.txt", commonFolder);
        private Thread utilityThread;


        string clientDBIP;
        string clientDBPort;
        string clientDBUserName;
        string clientDBPassword;
        string clientDBName;
        string ServerDBIP;
        string ServerDBPort;
        string ServerDBUserName;
        string ServerDBPassword;
        string ServerDBName;
        string Interval;
        string comparedbPath;
        string mysqlPath;

        public Service1()
        {
            InitializeComponent();
            if (!System.Diagnostics.EventLog.SourceExists("Gravity"))
            {
                System.Diagnostics.EventLog.CreateEventSource(
                    "Gravity", "GravityLog");
            }
            eventLog1.Source = "Gravity";
            eventLog1.Log = "";
        }

        static Timer timer;
        protected override void OnStart(string[] args)
        {
            ThreadStart start = new ThreadStart(readConfigFile);
            utilityThread = new Thread(start);
            utilityThread.Start();
        }

        private void TimerTick(object obj)
        {
            runCompareUtility();
        }
        protected override void OnStop()
        {
        }


        private void writeConfigFile()
        {
            eventLog1.WriteEntry("checking config file exist "+ gravityConfig + " " +File.Exists(gravityConfig));
            if (!File.Exists(gravityConfig)){
                Directory.CreateDirectory(gravityDir);
                UserInput ui = new UserInput();
                ui.Show();
                eventLog1.WriteEntry("userForm opened");
            }

        }

        private void readConfigFile()
        {
            if (File.Exists(gravityConfig))
            {
                eventLog1.WriteEntry("Reading Config file.");
                string[] lines = File.ReadAllLines(gravityConfig);
                foreach (string line in lines)
                {
                    if (line.IndexOf("clientDBIP:") >= 0)
                        clientDBIP = line.Substring(line.IndexOf("clientDBIP:") + "clientDBIP:".Length, line.Length - "clientDBIP:".Length);
                    if (line.IndexOf("clientDBPort:") >= 0)
                        clientDBPort = line.Substring(line.IndexOf("clientDBPort:") + "clientDBPort:".Length, line.Length - "clientDBPort:".Length);
                    if (line.IndexOf("clientDBUserName:") >= 0)
                        clientDBUserName = line.Substring(line.IndexOf("clientDBUserName:") + "clientDBUserName:".Length, line.Length - "clientDBUserName:".Length);
                    if (line.IndexOf("clientDBPassword:") >= 0)
                        clientDBPassword = line.Substring(line.IndexOf("clientDBPassword:") + "clientDBPassword:".Length, line.Length - "clientDBPassword:".Length);
                    if (line.IndexOf("clientDBName:") >= 0)
                        clientDBName = line.Substring(line.IndexOf("clientDBName:") + "clientDBName:".Length, line.Length - "clientDBName:".Length);
                    if (line.IndexOf("ServerDBIP:") >= 0)
                        ServerDBIP = line.Substring(line.IndexOf("ServerDBIP:") + "ServerDBIP:".Length, line.Length - "ServerDBIP:".Length);
                    if (line.IndexOf("ServerDBPort:") >= 0)
                        ServerDBPort = line.Substring(line.IndexOf("ServerDBPort:") + "ServerDBPort:".Length, line.Length - "ServerDBPort:".Length);
                    if (line.IndexOf("ServerDBUserName:") >= 0)
                        ServerDBUserName = line.Substring(line.IndexOf("ServerDBUserName:") + "ServerDBUserName:".Length, line.Length - "ServerDBUserName:".Length);
                    if (line.IndexOf("ServerDBPassword:") >= 0)
                        ServerDBPassword = line.Substring(line.IndexOf("ServerDBPassword:") + "ServerDBPassword:".Length, line.Length - "ServerDBPassword:".Length);
                    if (line.IndexOf("ServerDBName:") >= 0)
                        ServerDBName = line.Substring(line.IndexOf("ServerDBName:") + "ServerDBName:".Length, line.Length - "ServerDBName:".Length);
                    if (line.IndexOf("Interval:") >= 0)
                        Interval = line.Substring(line.IndexOf("Interval:") + "Interval:".Length, line.Length - "Interval:".Length);
                    if (line.IndexOf("CompareUtility:") >= 0)
                        comparedbPath = line.Substring(line.IndexOf("CompareUtility:") + "CompareUtility:".Length, line.Length - "CompareUtility:".Length);
                    if (line.IndexOf("MysqlPath:") >= 0)
                        mysqlPath = line.Substring(line.IndexOf("MysqlPath:") + "MysqlPath:".Length, line.Length - "MysqlPath:".Length);
                }

                eventLog1.WriteEntry("Backup will start after every " + Convert.ToDouble(Interval) + " Minutes.");
                timer = new Timer(TimerTick, null, TimeSpan.Zero,
                    TimeSpan.FromMinutes(Convert.ToDouble(Interval)));
            }
            else
            {
                eventLog1.WriteEntry("Config file not found.");
            }
        }

        private void runCompareUtility()
        {
            eventLog1.WriteEntry("Reading Differences in databases.");
            try
            {
                string sqlCompare = "--server1="+clientDBUserName+":"+clientDBPassword+"@"+clientDBIP+":"+clientDBPort +
                    " --server2="+ServerDBUserName+":"+ServerDBPassword+"@"+ServerDBIP+":"+ServerDBPort + " --run-all-tests " +clientDBName+":"+ServerDBName+" --changes-for=server2 --difftype=sql";
                eventLog1.WriteEntry("On start started");
                Process cmd = new Process();
                eventLog1.WriteEntry("mysqldbcompare process object created "+ comparedbPath );
                cmd.StartInfo.FileName = comparedbPath;
                cmd.StartInfo.Arguments = sqlCompare;
                cmd.StartInfo.UseShellExecute = false;
                cmd.StartInfo.RedirectStandardOutput = true;
                //cmd.StartInfo.RedirectStandardInput = true;
                cmd.StartInfo.CreateNoWindow = true;
                eventLog1.WriteEntry("Command prompt starting. "+ sqlCompare);
                cmd.Start();
                eventLog1.WriteEntry("reading output");

                StreamReader reader = cmd.StandardOutput;
                string output = reader.ReadToEnd();
                reader.Close();

                //eventLog1.WriteEntry("Kishor is Testing event log");
                //cmd.StandardInput.WriteLine("Kishor is Testing command line.");
                eventLog1.WriteEntry(output);

                using (StreamWriter sw = new StreamWriter(String.Format("{0}/diff.sql", gravityDir)))
                {
                    sw.WriteLine(output);
                }
                modifyOutputFile();
                   
                cmd.WaitForExit();
                cmd.Close();
                //cmd.StandardInput.Flush();
                //cmd.StandardInput.Close();
            }
            catch (Exception ex)
            {
                eventLog1.WriteEntry("EXCEPTION " + ex);
            }
        }

        private void modifyOutputFile()
        {
            string[] lines = File.ReadAllLines(String.Format("{0}/diff.sql", gravityDir));
            List<string> newlines = new List<string>();
            foreach (string line in lines)
            {
                if (line.IndexOf("-") == 0 || line.IndexOf("+") == 0 || line.IndexOf("@") == 0)
                {
                    newlines.Add(line.Replace(line, "# " + line));
                }
                else
                    newlines.Add(line);
            }

            using (StreamWriter sw = new StreamWriter(String.Format("{0}/diff.sql", gravityDir)))
            {
                foreach (string line in newlines)
                {
                    sw.WriteLine(line);
                }
            }
            runImport();
        }

        private void runImport()
        {
            try
            {
                string sqlCompare = " -C -B --host="+ServerDBIP+" --port="+ServerDBPort+" --user="+ServerDBUserName+" --password="+ServerDBPassword+" --database="+  ServerDBName +" -e '\\. "+String.Format("{0}/diff.sql",gravityDir) +"'";
                eventLog1.WriteEntry("On start started");
                Process cmd = new Process();
                eventLog1.WriteEntry("mysql process object created "+ sqlCompare);
                cmd.StartInfo.FileName = mysqlPath;
                cmd.StartInfo.Arguments = sqlCompare;
                cmd.StartInfo.UseShellExecute = false;
                cmd.StartInfo.RedirectStandardOutput = true;
                //cmd.StartInfo.RedirectStandardInput = true;
                cmd.StartInfo.CreateNoWindow = true;
                eventLog1.WriteEntry("mysql Command prompt starting. "+ mysqlPath);
                cmd.Start();
                eventLog1.WriteEntry("reading output for mysql");

                StreamReader reader = cmd.StandardOutput;
                string output = reader.ReadToEnd();
                reader.Close();

                //eventLog1.WriteEntry("Kishor is Testing event log");
                //cmd.StandardInput.WriteLine("Kishor is Testing command line.");
                eventLog1.WriteEntry(output);

                using (StreamWriter sw = new StreamWriter(String.Format("{0}/import.sql", gravityDir)))
                {
                    sw.WriteLine(output);
                }

                cmd.WaitForExit();
                cmd.Close();
                //cmd.StandardInput.Flush();
                //cmd.StandardInput.Close();
            }
            catch (Exception ex)
            {
                eventLog1.WriteEntry("EXCEPTION " + ex);
            }

        }
    }
}
