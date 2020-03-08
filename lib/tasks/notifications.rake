#!/usr/bin/env ruby

namespace :notifications do
  desc "Creates notifications based on current data at the time of generation"
  task :generate => :environment do
    puts "Generating notifications for /admin/dashboard..."

    #
    # There are 4 kinds of notifications we need here:
    #   1. If a device reports CO over 9PPM;
    #   2. If a device reports health status of "needs_service";
    #   3. If a device reports health status of "needs_new_filter"; or
    #   4. If a device reports health status of "gas_leak".
    #

    #
    # Carbon Monoxide Notification
    #
    Telemetry.where('carbon_monoxide > ? AND recorded_at > ?', 9.0, 24.hours.ago).select("DISTINCT(device_id), carbon_monoxide").each do |t|
      Notification.create(
        msg: "Device #{t.device.serial_no} has carbon monoxide level > 9PPM (#{t.carbon_monoxide})!",
        device: t.device
      )
    end

    #
    # needs_service
    #
    Telemetry.where('health = ? AND recorded_at > ?', 'needs_service', 24.hours.ago).select("DISTINCT(device_id), health").each do |t|
      Notification.create(
        msg: "Device #{t.device.serial_no} needs service.",
        device: t.device
      )
    end

    #
    # needs_new_filter
    #
    Telemetry.where('health = ? AND recorded_at > ?', 'needs_new_filter', 24.hours.ago).select("DISTINCT(device_id), health").each do |t|
      Notification.create(
        msg: "Device #{t.device.serial_no} needs a new filter.",
        device: t.device
      )
    end

    #
    # gas_leak
    #
    Telemetry.where('health = ? AND recorded_at > ?', 'gas_leak', 24.hours.ago).select("DISTINCT(device_id), health").each do |t|
      Notification.create(
        msg: "Device #{t.device.serial_no} has recorded a gas leak!",
        device: t.device
      )
    end

  end
end