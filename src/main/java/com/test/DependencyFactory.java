
package com.test;

import software.amazon.awssdk.http.apache.ApacheHttpClient;
import software.amazon.awssdk.services.ec2.Ec2Client;
import software.amazon.awssdk.services.rds.RdsClient;

/**
 * The module containing all dependencies required by the {@link Handler}.
 */
public class DependencyFactory {

  private DependencyFactory() {
  }

  /**
   * @return an instance of RdsClient
   */
  public static RdsClient rdsClient() {
    return RdsClient.builder().httpClientBuilder(ApacheHttpClient.builder()).build();
  }

  public static Ec2Client ec2Client() {
    return Ec2Client.builder().httpClientBuilder(ApacheHttpClient.builder()).build();
  }
}
