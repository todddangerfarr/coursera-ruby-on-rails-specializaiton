class Racer
  include ActiveModel::Model

  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

  # initialize from both a Mongo and Web hash
	def initialize(params={})
    @id=params[:_id].nil? ? params[:id] : params[:_id].to_s
    @number=params[:number].to_i
    @first_name=params[:first_name]
    @last_name=params[:last_name]
    @gender=params[:gender]
    @group=params[:group]
    @secs=params[:secs].to_i
  end

  # tell Rails whether this instance is persisted
	# aka has the primary key been assigned.
  def persisted?
    !@id.nil?
  end
  # JSON marshalling will also expect these two methods
  def created_at
    nil
  end
  def updated_at
    nil
  end

  # convenience method for access to the client in the console
  def self.mongo_client
    Mongoid::Clients.default
  end

  # convenience method for access to the zips collection
  def self.collection
    self.mongo_client['racers']
  end

  # implement a find that returns a collection of documents as hashes.
  # Use initialize(hash) to express individual documents as a class instance
  #     * prototype - query example for value equality
  #     * sort - hash expressing multi-term sort order
  #     * skip - document to start results
  #     * limit - number of documents to include
  def self.all(prototype={}, sort={:number=>1}, skip=0, limit=nil)
    result=collection.find(prototype)
          .sort(sort)
          .skip(skip)
    result=result.limit(limit) if !limit.nil?

    return result
  end

  #implememts the will_paginate paginate method that accepts
  # page - number >= 1 expressing offset in pages
  # per_page - row limit within a single page
  # also take in some custom parameters like
  # sort - order criteria for document
  # (terms) - used as a prototype for selection
  # This method uses the all() method as its implementation
  # and returns instantiated Zip classes within a will_paginate
  # page
  def self.paginate(params)
    Rails.logger.debug("paginate(#{params})")

    page=(params[:page] || 1).to_i
    limit=(params[:per_page] || 30).to_i
    skip=(page-1)*limit
    sort=params[:sort] ||= {'number': 1}

    # get the associated page of Racers -- eagerly convert doc to Racer
    racers=[]
    all({}, sort, skip, limit).each do |doc|
      racers << Racer.new(doc)
    end

    #get a count of all documents in the collection
    total=all({}, sort, 0, 1).count

    WillPaginate::Collection.create(page, limit, total) do |pager|
      pager.replace(racers)
    end
  end

  # locate a specific document.  Use initialize(hash) on the result to get in
  # class instance form
  def self.find id
    Rails.logger.debug { "getting racer #{id}" }

    result=collection.find({'_id': BSON::ObjectId.from_string(id)}).first
    return result.nil? ? nil : Racer.new(result)
  end

  # create a new document using the current instance
  def save
    Rails.logger.debug { "saving #{self}" }

    result=self.class.collection
                     .insert_one(number: @number, first_name: @first_name,
                                 last_name: @last_name, gender: @gender,
                                 group: @group, secs: @secs)
    @id=result.inserted_id.to_s
  end

  # update the values for this instance
  def update(params)
    Rails.logger.debug {"updating #{self} with #{params}"}

    @number=params[:number].to_i
    @first_name=params[:first_name]
    @last_name=params[:last_name]
    @gender=params[:gender]
    @group=params[:group]
    @secs=params[:secs].to_i

    params.slice!(:number, :first_name, :last_name, :gender, :group, :secs) if !params.nil?
    self.class.collection
              .find(:_id => BSON::ObjectId.from_string(@id))
              .update_one(params)
  end

  # remove the document associated with this instance form the DB
  def destroy
    Rails.logger.debug {"destroying #{self}"}

    self.class.collection
              .find(:_id => BSON::ObjectId.from_string(@id))
              .delete_one
  end

end
