package com.test;

import software.amazon.awssdk.services.ec2.Ec2Client;
import software.amazon.awssdk.services.ec2.model.DescribeSubnetsRequest;
import software.amazon.awssdk.services.ec2.model.DescribeSubnetsResponse;
import software.amazon.awssdk.services.rds.RdsClient;
import software.amazon.awssdk.services.rds.model.*;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;


public class Handler {
  private final RdsClient rdsClient;
  private final Ec2Client ec2Client;
  private final String DATABASE = "test-web-downgrade";
  private final String REGION = "us-east-1";
  private final String NATIVE_BACKUP_RESTORE_FEATURE = "SQLSERVER_BACKUP_RESTORE";

  private String engine = "";

  private String majorEngineVersion = "";

  private String newOptionGroupName() {
    return engine + "-" + majorEngineVersion + "-" + "native-backup-and-restore";
  }

  public Handler() {
    rdsClient = DependencyFactory.rdsClient();
    ec2Client = DependencyFactory.ec2Client();
  }

  private class CustomResponse {
    private String client;
    private String engine;
    private String dbInstanceId;

    @Override
    public String toString() {
      return "CustomResponse{" +
          "client='" + client + '\'' +
          ", engine='" + engine + '\'' +
          ", dbInstanceId='" + dbInstanceId + '\'' +
          '}';
    }

    CustomResponse(String client, String engine, String dbInstanceId) {
      this.client = client;
      this.engine = engine;
      this.dbInstanceId = dbInstanceId;
    }

  }

  private Filter createFilter(String name, String... values) {
    Filter.Builder filterBuilder = Filter.builder();
    filterBuilder.name(name);
    filterBuilder.values(values);
    return filterBuilder.build();
  }

  public void doStuff() {

    /////////////////////////////////////////////////////////
    //    Get Database Engine and Major Engine Version      //
    //                                                      //
    //    We need these values to search for and create     //
    //    option groups. An option group is tied to a       //
    //    specific engine and major engine version          //
    /////////////////////////////////////////////////////////
//    DescribeDbInstancesResponse describeDbInstancesResponse = rdsClient.describeDBInstances(
//        DescribeDbInstancesRequest
//            .builder()
    //      .dbInstanceIdentifier(DATABASE)
//            .build()
//    );
//    DescribeDbInstancesResponse describeDbInstancesResponse = rdsClient.describeDBInstances(
//        DescribeDbInstancesRequest
//            .builder()
//            .filters(Collections.singleton(createFilter(
//                    "engine",
//                    "sqlserver-ee",
//                    "sqlserver-se",
//                    "sqlserver-ex",
//                    "sqlserver-web"
//                ))
//            )
//            .build()
//    );



    DescribeDbInstancesResponse describeDbInstancesResponse = rdsClient.describeDBInstances(
        DescribeDbInstancesRequest
            .builder()
            .dbInstanceIdentifier("nymbl-db-sandbox")
            .build()
    );


    if (!describeDbInstancesResponse.hasDbInstances()) return;

    describeDbInstancesResponse
        .dbInstances()
        .forEach(dbInstance -> {
          DBSubnetGroup subnetGroup = dbInstance.dbSubnetGroup();
          List<String> subnets = subnetGroup.subnets().stream().map(subnet -> subnet.subnetIdentifier()).collect(Collectors.toList());
          DescribeSubnetsResponse foo = ec2Client.describeSubnets(DescribeSubnetsRequest.builder().subnetIds(subnets).build());
          foo.subnets().forEach(s -> {
            System.out.println(s.);
          });
        });

//    Collection<CustomResponse> customResponses = describeDbInstancesResponse
//        .dbInstances()
//        .stream()
//        .map(dbInstance -> {
//          String client = "";
//          if (dbInstance.hasTagList()) {
//            List<Tag> tags = dbInstance.tagList().stream().filter(tag -> tag.key().matches("Client")).collect(Collectors.toList());
//            if (tags.size() > 0) client = tags.get(0).value();
//          }
//          String engine = dbInstance.engine();
//          String dbInstanceId = dbInstance.dbInstanceIdentifier();
//          CustomResponse customResponse = new CustomResponse(client, engine, dbInstanceId);
//          System.out.println(customResponse);
//          return customResponse;
//        }).collect(Collectors.toList());
////    DBInstance dbInstance = describeDbInstancesResponse.dbInstances().get(0);


    // Get Engine
//    setEngine(describeDbInstancesResponse.dbInstances().get(0).engine());

    // Get Engine Version
//    String engineVersion = describeDbInstancesResponse.dbInstances().get(0).engineVersion();

    // Get Major Engine Version
//    DescribeDbEngineVersionsResponse describeDBEngineVersionsResponse = rdsClient.describeDBEngineVersions(
//        DescribeDbEngineVersionsRequest
//            .builder()
//            .engine(engine)
//            .engineVersion(engineVersion)
//            .build());

//    if (!describeDBEngineVersionsResponse.hasDbEngineVersions()) return;

//    String majorEngineVersion = describeDBEngineVersionsResponse.dbEngineVersions().get(0).majorEngineVersion();

    // Get existing option group memberships for database
//    if (dbInstance.hasOptionGroupMemberships()) {
//      dbInstance.optionGroupMemberships().stream().map(optionGroup -> {
//            DescribeOptionGroupsResponse describeOptionGroupsResponse = rdsClient.describeOptionGroups(
//                DescribeOptionGroupsRequest
//                    .builder()
//                    .optionGroupName(optionGroup.optionGroupName())
//                    .build()
//            );
//            if (describeOptionGroupsResponse.hasOptionGroupsList()) {
//              describeOptionGroupsResponse.optionGroupsList().stream().filter(o -> o.hasOptions() && o.options())
//            }
//          })
//          .filter(name -> name == NATIVE_BACKUP_RESTORE_FEATURE)
//          .collect(Collectors.toList());
//
//      if (optionNames.isEmpty()) {
//        rdsClient.createOptionGroup();
//      }
  }


  public void setEngine(String engine) {
    this.engine = engine;
  }

  public void setMajorEngineVersion(String majorEngineVersion) {
    this.majorEngineVersion = majorEngineVersion;
  }

  public String getOptionGroupName() {
    return engine + majorEngineVersion + "native-backup";
  }
}
