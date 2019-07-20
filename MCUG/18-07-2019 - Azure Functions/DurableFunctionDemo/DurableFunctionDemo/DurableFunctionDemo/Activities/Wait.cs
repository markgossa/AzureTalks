using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Threading;
using FunctionApp1.DurableFunctions.FanOutIn.Models;

namespace FunctionApp1.DurableFunctions.FanOutIn.Activities
{
    public class Wait
    {
        [FunctionName("Wait")]
        public async Task<string> Run(
            [ActivityTrigger] FanInfo fanInfo,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            Thread.Sleep(fanInfo.SleepTime);

            return $"Wait function slept for {fanInfo.SleepTime / 1000} seconds";
        }
    }
}
