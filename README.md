# Rein

Database constraints made easy for ActiveRecord.

## Introduction

ActiveRecord doesn't make it easy for you to weild the power of your database.

## Quick Start

First, install the gem:

    gem install rein

Then slap some constraints in your migrations. For example:

    add_numericality_constraint :my_table, :my_field, :greater_than_or_equal_to => 0
