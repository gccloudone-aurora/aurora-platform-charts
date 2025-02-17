# Prometheus Certmanager Certificate Rules Testing Document

## Assumptions
* At any one moment, only **one** state (unknown, false, true) for the ready condition will have a value of one in the metrics.
* If the state of the ready condition is **not** true, then the certificate is assumed to be dysfunctional.

## Command to run tests
```
promtool test rules tests/*.yaml
```

# Alert: certManagerCertFailingToRenew

## Expression
```
(sum by (name) (time() > certmanager_certificate_renewal_timestamp_seconds) ) AND (sum by (name) (time() < certmanager_certificate_expiration_timestamp_seconds))
```

## Description

This alert should fire if the current date has passed the renewal time but it has not yet passed the expiry time.

## Truth Table (MC/DC)
|  Cond_1 	|  Cond_2 	|  Result 	|   Test Case	|
|-----------|-----------|-----------|---------------|
|   T	    |   T	    |   T	    |   	TC1     |
|   T	    |   F	    |   F	    |   	TC2     |
|   F	    |   T	    |   F	    |   	TC3     |

## TC1
### Input
* Renewal Date = Jan 1st 1970
* Expiry Date = Oct 2nd 2096

### Expected Output
* Alert fires: certManagerCertFailingToRenew

## TC2
### Input
* Renewal Date = Jan 1st 1970
* Expiry Date = Jan 1st 1970

### Expected Output
* No alert fires

## TC3
### Input
* Renewal Date = Oct 2nd 2096
* Expiry Date = Oct 2nd 2096

### Expected Output
* No alert fires

# Alert: certManagerCertFailure

## Expression
```
sum by (name) (certmanager_certificate_ready_status{condition="True"}==0) AND (sum by (name) (time() < certmanager_certificate_renewal_timestamp_seconds))
```

## Description

This alert should fire if the ready status of the certificate is **not** true but the current date is before the renewal date of the cert-manager certificate.
## Truth Table (MC/DC)
|  Cond_1 	|  Cond_2 	|   Result 	|   Test Case	|
|-----------|-----------|-----------|---------------|
|   T	    |   T	    |     T	    |   	TC4     |
|   T	    |   F	    |     F	    |   	TC5     |
|   F	    |   T	    |     F	    |   	TC6     |


## TC4
### Input
* Ready Status Condition = Not True (0)
* Renewal Date = Oct 2nd 2096

### Expected Output
* Alert fires: certManagerCertFailure


## TC5
### Input
* Ready Status Condition = Not True (0)
* Renewal Date = Jan 1st 1970

### Expected Output
* No alert fires

## TC6
### Input
* Ready Status Condition = True (1)
* Renewal Date = Oct 2nd 2096

### Expected Output
* No alert fires

# Alert: certManagerCertExpired

## Expression
```
sum by (name) (time() > certmanager_certificate_expiration_timestamp_seconds)
```

## Description

This alert should fire if the current date has exceeded the expiry date of the certificate.

## Truth Table (MC/DC)
|  Cond_1 	|    Result 	|   Test Case	|
|-----------|---------------|---------------|
|     T	    |   	T       |      TC7      |
|     F	    |   	F       |      TC8      |



## TC7
### Input
* Expiry Date = Jan 1st 1970

### Expected Output
* Alert fires: certManagerCertExpired


## TC8
### Input
* Expiry Date = Oct 2nd 2096

### Expected Output
* No alert fires


# Alert: certManagerAbsent

## Expression
```
absent(up{job="cert-manager"})
```

## Description

This alert should fire if cert-manager has disappeared from Prometheus service discovery. New certificates will not be able to be minted, and existing ones cannot be renewed until cert-manager is back.


## Truth Table (MC/DC)
|  Cond_1 	|    Result 	|   Test Case	|
|-----------|---------------|---------------|
|     T	    |   	T       |      TC9      |
|     F	    |   	F       |      TC10     |


## TC9
### Input
* Empty; No job

### Expected Output
* Alert fires: certManagerAbsent


## TC10
### Input
* Job exists

### Expected Output
* No alert fires

# Alert: certManagerHittingRateLimits

## Expression
```
sum by (host) (rate(certmanager_http_acme_client_request_count{status="429"}[5m])) > 0
```

## Description

This alert fires if Cert manager is hitting LetsEncrypt rate limits. Depending on the rate limit, cert-manager may be unable to generate certificates for up to a week.

## Truth Table (MC/DC)
|  Cond_1 	|    Result 	|   Test Case	|
|-----------|---------------|---------------|
|     T	    |   	T       |     TC11      |
|     F	    |   	F       |     TC12      |


## TC11
### Input
* A metric with HTTP status 429 that has a rate of 0.133 from [5m, 10m]

### Expected Output
* Alert fires: certManagerHittingRateLimits


## TC12
### Input
* A metric with HTTP status 429 that has a rate of 0 from [5m, 10m]

### Expected Output
* No alert fires
