dotnet
{
    assembly("Seagull.BarTender.Print")
    {
        Version = '11.2.1.1';
        Culture = 'neutral';
        PublicKeyToken = '109ff779a1b4cbc7';

        type("Seagull.BarTender.Print.Engine"; "Engine")
        {
        }

        type("Seagull.BarTender.Print.LabelFormatDocument"; "LabelFormatDocument")
        {
        }

        type("Seagull.BarTender.Print.CommandLineCompletedEventArgs"; "CommandLineCompletedEventArgs")
        {
        }

        type("Seagull.BarTender.Print.PrintJobEventArgs"; "PrintJobEventArgs")
        {
        }

        type("Seagull.BarTender.Print.JobSentEventArgs"; "JobSentEventArgs")
        {
        }

        type("Seagull.BarTender.Print.MonitorErrorEventArgs"; "MonitorErrorEventArgs")
        {
        }
    }

}
