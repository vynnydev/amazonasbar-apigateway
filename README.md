# amazonas-bar

## Application under development!!

Event driven app that mirrors order processing in a amazonas bar based on AWS resources managed via terraform

- Public gateway used for providing public access for placing Orders, can also plug in to an identity provider for authorizing clients/users.
- To enable clients to register events without changing backend code, you can [send client events](https://aws.amazon.com/blogs/compute/capturing-client-events-using-amazon-api-gateway-and-amazon-eventbridge/) to EventBridge via an API Gateway
- The internal AWS API Gateway performs validation on published events. It [supports](https://docs.aws.amazon.com/apigateway/latest/developerguide/models-mappings.html#models-mappings-models) Draft 4 of JSON Schema and plug the schema into an API endpoint in order to reject any requests that don’t conform to the schema.
- The event bus has a rule to dispatch order events to the delivery lambda. You can only create scheduled rules using the default event bus
- EventBridge has a hard limit on the event size at 265 KB

<img src="./docs/architecture.png" title="Event Driven Architecture" height="450" width="800"/>

## Build the apps (lambda functions)

The apps are built using `esbuild` and packaged with `zip` as detailed [here](https://docs.aws.amazon.com/lambda/latest/dg/typescript-package.html)

> If you do not have the executable zip, follow the instruction [in this guide](https://matteus.dev/zip-for-windows-como-instalar-o-comando-zip/).

```sh
make build APP=orders
make build APP=delivery
```

## Deploy the stack

The infrastructure and apps are deployed using `terraform`

```sh
# Provision the stack
make stack APPLY=true

# Tear down
make destroy-stack
```

## Get orders

```sh
cd provisioning
curl "$(terraform output -raw orders_api_url)/orders"
```

## Run load tests

- Pre requisites - Install [pipenv](https://packaging.python.org/en/latest/tutorials/managing-dependencies/)

    ```sh
    python3 -m pip install --user pipenv
    ```

- Run load test
  
    ```sh
    # get ORDERS_API_ID by loading terraform output
    make output

    # Terraform out put looks like:
    # orders_api_url = "https://e60e2y07o4.execute-api.eu-west-1.amazonaws.com/amazonasbar

    # run the load test
    make loadtest ORDERS_API_ID=e60e2y07o4
    ```
