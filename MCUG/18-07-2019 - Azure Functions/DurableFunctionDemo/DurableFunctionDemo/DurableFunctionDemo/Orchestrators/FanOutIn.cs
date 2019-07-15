using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FunctionApp1.DurableFunctions.FanOutIn.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace FunctionApp1.DurableFunctions.FanOutIn.Orchestrators
{
    public static class FanOutIn
    {
        [FunctionName("FanOutIn")]
        public static async Task<List<string>> RunOrchestrator(
            [OrchestrationTrigger] DurableOrchestrationContext context,
            ILogger log)
        {

            var fanInfo = context.GetInput<FanInfo>();

            var tasks = new List<Task<string>>();
            for (int i = 0; i < fanInfo.Count; i++)
            {
                log.LogInformation($"Starting wait number {i + 1} of fanInfo.Count");
                tasks.Add(context.CallActivityAsync<string>("Wait", fanInfo));
            }

            await Task.WhenAll(tasks);

            return tasks.Select(x => x.Result).ToList();
        }
    }
}