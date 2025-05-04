# External DNS

If you are starting a new cluster that will expose apps on a different domain name, follow this instructions:

## Creating a zone with OVHCloud DNS

If you are new to OVHcloud, we recommend you first read the following instructions for creating a zone.

[Creating a zone using the OVHcloud API](https://api.ovh.com/console/)

## Creating OVHcloud Credentials

You first need to create an OVHcloud application: follow the
[OVHcloud documentation](https://help.ovhcloud.com/csm/en-gb-api-getting-started-ovhcloud-api?id=kb_article_view&sysparm_article=KB0042784#advanced-usage-pair-ovhcloud-apis-with-an-application)
 you will have your `Application key` and `Application secret`

And you will need to generate your consumer key, here the permissions needed :

- GET on `/domain/zone`
- GET on `/domain/zone/*/record`
- GET on `/domain/zone/*/record/*`
- PUT on `/domain/zone/*/record/*`
- POST on `/domain/zone/*/record`
- DELETE on `/domain/zone/*/record/*`
- GET on `/domain/zone/*/soa`
- POST on `/domain/zone/*/refresh`

After getting the credentials, you'll need to update sealed secrets of the external DNS manifests.
