# Rein

Database constraints made easy for ActiveRecord.


## Introduction

Rein adds bunch of methods to your ActiveRecord migrations so you can easily tame your database.

ActiveRecord doesn't make it easy for you to weild the power of your database.


## Quick Start

First, install the gem:

    gem install rein

Then slap some constraints in your migrations. For example:

    add_numericality_constraint :books, :publication_month, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 12
