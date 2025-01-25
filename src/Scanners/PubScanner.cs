using System;
using System.Threading.Tasks;
using YamlDotNet.Serialization;

namespace NuGuard.Scanners
{
    public class PubScanner : IPackageScanner
    {
        public string ProjectType => "pub";

        public async Task<ScanResult> ScanProjectAsync(string projectPath)
        {
            var result = new ScanResult();

            try
            {
                var pubspecPath = Path.Combine(projectPath, "pubspec.yaml");
                if (!File.Exists(pubspecPath))
                {
                    throw new FileNotFoundException("pubspec.yaml not found", pubspecPath);
                }

                var deserializer = new DeserializerBuilder().Build();
                var pubspec = deserializer.Deserialize<Dictionary<string, object>>(
                    await File.ReadAllTextAsync(pubspecPath));

                if (pubspec.TryGetValue("dependencies", out var depsObj))
                {
                    var dependencies = depsObj as Dictionary<object, object>;
                    if (dependencies != null)
                    {
                        foreach (var dep in dependencies)
                        {
                            // TODO: Implement vulnerability checking against a security database
                            // This could involve checking against the Google OSV database
                            // https://osv.dev/list?ecosystem=Pub

                            result.AddPackage(new Package
                            {
                                Name = dep.Key.ToString(),
                                Version = dep.Value?.ToString() ?? "unknown",
                                Source = "pub.dev"
                            });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                result.AddError($"Error scanning Pub packages: {ex.Message}");
            }

            return result;
        }
    }
}
