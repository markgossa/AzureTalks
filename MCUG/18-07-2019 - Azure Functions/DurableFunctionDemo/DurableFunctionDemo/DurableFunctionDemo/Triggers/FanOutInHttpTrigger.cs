using System;
using System.Net.Http;
using System.Threading.Tasks;
using FunctionApp1.DurableFunctions.FanOutIn.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;

namespace FunctionApp1.DurableFunctions.FanOutIn.Triggers
{
    public static class FanOutInHttpTrigger
    {
        [FunctionName("FanOutIn_HttpStart")]
        public static async Task<HttpResponseMessage> HttpStart(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post")]HttpRequestMessage req,
            [OrchestrationClient]DurableOrchestrationClient starter,
            ILogger log)
        {

            var fanInfo = await req.Content.ReadAsAsync<FanInfo>();

            string instanceId = await starter.StartNewAsync("FanOutIn", fanInfo);

            log.LogInformation($"Started orchestration with ID = '{instanceId}'.");

            //return starter.CreateCheckStatusResponse(req, instanceId);
            return await starter.WaitForCompletionOrCreateCheckStatusResponseAsync(req, instanceId,
                TimeSpan.FromSeconds(300), TimeSpan.FromMilliseconds(250));
        }
    }
}