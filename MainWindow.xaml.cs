using System.Diagnostics;
using System.IO;
using System.Windows;
using FFXILauncher.Services;
using Microsoft.Win32;

namespace FFXILauncher;

public partial class MainWindow : Window
{
    // ╔══════════════════════════════════════════════════════════════════════╗
    // ║  SERVER CONFIGURATION — edit these before building                  ║
    // ╠══════════════════════════════════════════════════════════════════════╣
    private const string ServerHost    = "192.168.68.50";
    private const string ProfileName   = "myprivateserver";
    private const string ManifestUrl   = PatchManager.DefaultManifestUrl;
    // ╚══════════════════════════════════════════════════════════════════════╝

    private readonly string _ashitaRoot;
    private CancellationTokenSource? _cts;

    public MainWindow()
    {
        InitializeComponent();
        _ashitaRoot = Path.Combine(AppContext.BaseDirectory, "Ashita");
        LoadSettings();
        RunStartupChecks();
    }

    private void RunStartupChecks()
    {
        Log("=== FFXI Private Server Launcher ===");

        if (!string.IsNullOrEmpty(GamePathBox.Text) && GameDetector.IsValidGamePath(GamePathBox.Text))
            Log($"FFXI: {GamePathBox.Text}");
        else
        {
            var detected = GameDetector.DetectInstallPath();
            if (detected != null)
            {
                GamePathBox.Text = detected;
                SaveSettings();
                Log($"FFXI detected: {detected}");
            }
            else
                Log("WARNING: FFXI path not found. Use Browse to set it.");
        }

        var ashita = new AshitaManager(_ashitaRoot);
        if (ashita.IsAshitaPresent())
            Log($"Ashita: {_ashitaRoot}");
        else
            Log($"WARNING: ashita-cli.exe not found at:\n         {_ashitaRoot}");

        if (ManifestUrl.Contains("YOUR-SERVER"))
            Log("NOTE: Patch server not configured — ROM check will be skipped.");

        Log("Ready.");
    }

    private void BrowseButton_Click(object sender, RoutedEventArgs e)
    {
        var dlg = new OpenFileDialog
        {
            Title  = "Select FFXiMain.dll in your FFXI folder",
            Filter = "FFXiMain.dll|FFXiMain.dll|All Files (*.*)|*.*",
        };

        if (dlg.ShowDialog() != true) return;

        var dir = Path.GetDirectoryName(dlg.FileName)!;
        if (!GameDetector.IsValidGamePath(dir))
        {
            MessageBox.Show(
                "That folder doesn't look like a valid FFXI install.",
                "Invalid Path", MessageBoxButton.OK, MessageBoxImage.Warning);
            return;
        }

        GamePathBox.Text = dir;
        SaveSettings();
        Log($"Game path set: {dir}");
    }

    private async void LaunchButton_Click(object sender, RoutedEventArgs e)
    {
        if (!ValidateBeforeLaunch()) return;

        SetLaunching(true);
        _cts = new CancellationTokenSource();

        try
        {
            Log("Checking for ROM updates...");
            await PatchAsync(_cts.Token);

            var ashita = new AshitaManager(_ashitaRoot);
            var config = new AshitaConfig
            {
                ServerHost  = ServerHost,
                GamePath    = GamePathBox.Text,
                ProfileName = ProfileName,
            };

            var profilePath = ashita.WriteProfile(config);
            Log($"Ashita profile written: {profilePath}");

            Log("Launching game...");
            SetStatus("Launching...");

            var proc = ashita.Launch(config);
            Log($"Game started (PID {proc.Id}).");
            SetStatus("Game running.");
        }
        catch (OperationCanceledException)
        {
            Log("Launch cancelled.");
            SetStatus("Cancelled.");
        }
        catch (Exception ex)
        {
            Log($"ERROR: {ex.Message}");
            SetStatus("Error — see log.");
            MessageBox.Show(ex.Message, "Launch Failed",
                MessageBoxButton.OK, MessageBoxImage.Error);
        }
        finally
        {
            SetLaunching(false);
            _cts?.Dispose();
            _cts = null;
        }
    }

    private async Task PatchAsync(CancellationToken ct)
    {
        var patcher  = new PatchManager(GamePathBox.Text, ManifestUrl);
        var progress = new Progress<PatchProgress>(p =>
        {
            SetStatus(p.Status);
            PatchProgressBar.Value = p.Percent;
            if (!string.IsNullOrEmpty(p.Status)) Log(p.Status);
        });
        await patcher.CheckAndPatchAsync(progress, ct);
        PatchProgressBar.Value = 100;
    }

    private bool ValidateBeforeLaunch()
    {
        if (!GameDetector.IsValidGamePath(GamePathBox.Text))
        {
            MessageBox.Show("Please set a valid FFXI installation path.",
                "Invalid Path", MessageBoxButton.OK, MessageBoxImage.Warning);
            return false;
        }

        var ashita = new AshitaManager(_ashitaRoot);
        if (!ashita.IsAshitaPresent())
        {
            MessageBox.Show(
                $"ashita-cli.exe not found.\n\nExpected at:\n{_ashitaRoot}\n\n" +
                "Place your Ashita folder next to FFXILauncher.exe.",
                "Ashita Not Found", MessageBoxButton.OK, MessageBoxImage.Warning);
            return false;
        }

        return true;
    }

    private void SetLaunching(bool launching)
    {
        LaunchButton.IsEnabled = !launching;
        LaunchButton.Content   = launching ? "Launching..." : "PLAY";
        if (launching) PatchProgressBar.Value = 0;
    }

    private void SetStatus(string text) =>
        Dispatcher.Invoke(() => StatusLabel.Text = text);

    private void Log(string message) =>
        Dispatcher.Invoke(() =>
        {
            LogText.Text += $"[{DateTime.Now:HH:mm:ss}] {message}\n";
            LogScroll.ScrollToEnd();
        });

    private string SettingsPath =>
        Path.Combine(AppContext.BaseDirectory, "launcher.cfg");

    private void LoadSettings()
    {
        if (!File.Exists(SettingsPath)) return;
        foreach (var line in File.ReadAllLines(SettingsPath))
            if (line.StartsWith("gamepath=", StringComparison.OrdinalIgnoreCase))
                GamePathBox.Text = line["gamepath=".Length..];
    }

    private void SaveSettings() =>
        File.WriteAllText(SettingsPath, $"gamepath={GamePathBox.Text}");
}
