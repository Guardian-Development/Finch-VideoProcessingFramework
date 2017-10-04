[
    {
        "name" : "${client_service_application_name}-${client_service_application_version}",
        "image" : "${docker_image_source}/${docker_client_service_image_name}:${client_service_application_version}",
        "cpu" : 1024,
        "memory" : 768,
        "essential" : true,
        "portMappings" : [
            {
                "containerPort": 9000, 
                "hostPort" : 9000
            }
        ]
    }
]