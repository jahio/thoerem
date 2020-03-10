# SmartAC

Local developer setup:

`alias be="bundle exec"`

1. `git clone` this repo;
1. `be rake db:create && be rake db:migrate && be rake db:seed && be rake notifications:generate`
1. `be rspec` to run tests

The only external dependency this project has is a working PostgreSQL install
with the ability to `CREATE EXTENSION`s (for UUIDs).

## Misc. Notes

#### Tests/Specs

Not _everything_ is tested via specs. I'd like to do that, but since this
project is about tradeoffs, I haven't written specs for a lot of the admin
workflow. The workflow for registering a device and creating telemetry is tested
but that's about it.

### Security

#### The admin dashboard

Since it was mentioned in slack that it's OK to skip over the multiple admin
feature, I've just created a single admin with a hard-coded username and
password: `admin / lolpassword`. This is "good enough" for a 2-day demo, but
I would absolutely want to change this in a big way before deploying something
to production.

#### Device Registration/Telemetry

As it stands right now, when a device registers itself it tells the API what
its serial number is. Given the deadline in question it wasn't feasible to
set up some kind of authentication system, but in a perfect world I'd like to
generate an authentication token for the device upon its registration. The
device would need to submit that token (preferably as a header) with each
subsequent request (e.g. to report telemetry data). This would be done over
HTTPS (enforced at the operations level by SSL termination point and/or
load balancer) and any time it's missing I'd have the API respond with a
403 status code.

## API

The API is pretty simple overall. There are two URLs to work with:

| URL | Method | Parameters |
| --- | ------ | ---------- |
| `http://HOST/register` | POST | `device` - JSON payload of a device for registration (see below) |
| `http://HOST/t/:SERIAL_NO` | POST | `telemetry` - JSON payload for telemetry to report for the device identified by `SERIAL_NO` (see below) |

#### /register

This is used for registering a new device, and should only be accessed once
over the entire lifetime for a given device. We assume that each device has
a guaranteed unique serial number, so collision detection/resolution isn't
built in this iteration.

When you register a device, you create it in the system. You can't report
telemetry until a device is registered.

To create a device, send a JSON payload like the following (your values
substituted) to `/register`.

```json
{
  "device": {
    "serial_number":"NX0199473625F17BVN",
    "firmware_version":"222.365.21.4.998b"
  }
}
```

Upon successful completion of your registration, you'll get a `200 OK` status
code, and a JSON representation of the object created. If the JSON payload
doesn't parse correctly or another error occurs, you'll get a `400` bad request.

#### /t/:SERIAL_NO

To report device telemetry, an HTTP POST can be sent to `/t/:SERIAL_NO` where
your device's serial number is the final part of the URL. For example, say we
have a device with a serial number of `XYZ823` - we'd send a POST request to
`/t/XYZ823`.

You'll need to have a parameter named `telemetry` with a JSON payload like the
following (with your values substituted):

```json
{
  "telemetry": [
    {
      "carbon_monoxide":"0.05",
      "temp_c":"22.3",
      "humidity_percentage":"75.5",
      "health":"needs_service",
      "recorded_at":"2020-03-10 01:12:20"
    },
    {
      "carbon_monoxide":"0.05",
      "temp_c":"22.3",
      "humidity_percentage":"75.5",
      "health":"needs_new_filter",
      "recorded_at":"2020-03-10 01:12:20"
    },
    {
      "carbon_monoxide":"0.05",
      "temp_c":"22.3",
      "humidity_percentage":"75.5",
      "health":"gas_leak",
      "recorded_at":"2020-03-10 01:12:20"
    }
  ]
}
```

Upon success you'll receive a `200 OK` response code with a plain-text body
telling you the telemetry was recorded.

> How often can I send telemetry data?

As often as you want, but once per minute is the recommended maximum.

> How many telemetry objects can I include in my telemetry JSON?

As many as you want, but we recommend no more than 500.

> What if I only want to send one telemetry record at a time?

Keep the same JSON structure as above, just with only one object in the array.

## Notifications

Notifications are created by a rake task. Run `rake notifications:generate` to
start that task. It'll scan the telemetry records in the database and create
notifications for those devices as needed. It's recommended to put this under
cron so it'll run on a schedule. Once every 30 minutes or so should be about
right.