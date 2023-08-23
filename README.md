# application-on-cloud
A demo application for GitHub Actions, S3, S3 mountpoint integration test

![image](https://github.com/shamimice03/application-on-cloud/assets/19708705/74877bac-478e-4509-952e-465c134f553d)
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::391178969547:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:shamimice03/application001:ref:refs/heads/main"
                }
            }
        }
    ]
}
```

![image](https://github.com/shamimice03/application-on-cloud/assets/19708705/3bfc1bbb-78d4-4565-9e60-97466e28563a)


![image](https://github.com/shamimice03/application-on-cloud/assets/19708705/6bd4f669-4fc0-4423-88f9-0a3357b2d56e)


```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Principal": {
                "Federated": "arn:aws:iam::391178969547:oidc-provider/token.actions.githubusercontent.com"
            },
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": [
                        "sts.amazonaws.com"
                    ],
                    "token.actions.githubusercontent.com:sub": [
                        "repo:shamimice03/application001:ref:refs/heads/main"
                    ]
                }
            }
        }
    ]
}
```


